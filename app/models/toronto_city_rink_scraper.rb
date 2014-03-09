require "open-uri"

class TorontoCityRinkScraper

  HOST = "http://www1.toronto.ca"
  cattr_accessor :logger
  self.logger = Rails.logger

  attr_accessor :fetcher

  # seems like there may be a throttling mechanism on the rink sites,
  # requests fail if you do too many too quickly
  DEFAULT_SLEEP_SECONDS = 20

  class Fetcher
    def fetch(url, description=nil)
      start = Time.now
      logger.info "fetching #{description} from #{url}"
      open(url){ |f| f.read }.tap do
        logger.info "completed in #{Time.now - start}s"
      end
    end
  end

  def initialize(opts={})
    @sleep_seconds = opts[:sleep_seconds]
    @rink_ids = opts[:rink_ids]
    @time_range_parser = TimeRangeParser.new
    @schedule_entry_processor = ScheduleEntryProcessor.new
    @fetcher = Fetcher.new
  end

  def execute(opts={})
    rinks = load_rinks
    rinks.each_with_index do |rink, index|
      next if @rink_ids && !@rink_ids.include?(rink.id)

      update_rink_details(rink)
      if @sleep_seconds && index + 1 < rinks.size
        logger.info "Sleeping for #{@sleep_seconds}"
        sleep @sleep_seconds
      end
    end
  end

  def load_rinks
    logger.info "Updating rinks"
    rink_list_html = fetch("#{HOST}/parks/prd/skating/dropin/hockey/", "Rink list")
    schedule = Nokogiri::HTML(rink_list_html)
    created = 0
    links = schedule.css(".pfrProgramDescrList.dropinbox h4 a")
    rinks = []

    links.each do |link|
      rink_name = link.text.squish
      rink = Rink.find_by_name(rink_name)
      if rink.nil?
        logger.info "\t=> Creating rink: #{rink_name}"
        rink = Rink.create!(name: rink_name, url: HOST + link.attr("href"))
        created += 1
      end
      rinks << rink
    end
    logger.info "Processed #{links.size} rinks. Created #{created}"
    rinks
  end

  def update_rink_details(rink)
    raw_rink_detail_page = fetch(rink.url, "Rink details for #{rink.name}")
    rink_detail_page = Nokogiri::HTML(raw_rink_detail_page)

    rink_location = rink_detail_page.css(".pfrComplexLocation li:first").text
    geocode_result = Geocoder.search(rink_location).first
    logger.debug "Address for #{rink.name} is #{rink_location}: #{geocode_result.try(:latitude)}, #{geocode_result.try(:longitude)}"

    if geocode_result
      rink.update_attributes(address: rink_location, latitude: geocode_result.latitude, longitude: geocode_result.longitude)
    else
      Rails.logger.error "Error getting lat/lon for #{rink.name} at #{rink_location}"
    end

    schedule = rink_detail_page.css("#pfrComplexTabs-dropin").to_html
    schedule_entries = extract_schedule_entries(schedule)

    logger.info("#{rink.name}: extracted #{schedule_entries.size} entries")

    schedule_entries.each do |entry|
      scheduled_activity = @schedule_entry_processor.process(rink, entry)
      if ScheduledActivity.conflict_exists?(scheduled_activity)
        logger.debug("Already have activity for this slot...skipping #{scheduled_activity}")
      elsif !scheduled_activity.save
        logger.error("Error saving activity: #{scheduled_activity}: #{scheduled_activity.errors.full_messages}")
      end
    end
  end

  def extract_schedule_entries(activity_table_html)
    doc = Nokogiri::HTML(activity_table_html)
    schedule_tables = doc.css('tr[id^="dropin_Skating_"] table')

    schedule_entries = []

    schedule_tables.each do |table|
      date_for_column_index = {}
      table.css("thead tr th").each_with_index do |cell, index|
        date = begin
          Date.parse(cell.text)
        rescue ArgumentError => e
          nil
        end

        date_for_column_index[index] = date
      end

      table.css("tbody tr").each do |row|
        row_cols = row.css("td")
        next unless row_cols.size == date_for_column_index.size
        activity_name = row_cols[0].text.squish.gsub(/(\w)\(/, '\1 (')

        row_cols.each_with_index do |cell, index|
          next if index == 0
          next if cell.text.blank?
          date = date_for_column_index[index]
          if date.nil?
            logger.warn "Do not have date for column index #{index}"
            next
          end

          cell.to_html.split("<br>").each do |time_range_text|
            start_time_of_day, end_time_of_day = begin
              @time_range_parser.parse(time_range_text)
            rescue ArgumentError => e
              logger.warn("Could not parse time range: #{cell.text}")
            end

            entry = ScheduleEntry.new(activity_name,
              # gross!
              Time.zone.parse("#{date.to_s(:db)} #{start_time_of_day}"),
              Time.zone.parse("#{date.to_s(:db)} #{end_time_of_day}"))

            schedule_entries << entry
          end
        end
      end
    end

    schedule_entries
  end

  private

  def logger
    self.class.logger
  end

  def fetch(url, description=nil)
    @fetcher.fetch(url, description)
  end

end