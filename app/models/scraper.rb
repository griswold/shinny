require "open-uri"

class Scraper

  HOST = "http://www1.toronto.ca"

  def initialize
    @time_range_parser = TimeRangeParser.new
  end

  class ScheduleEntry < Struct.new(:label, :start_date, :end_date)
    def to_s
      "#{label}: #{start_date} - #{end_date}"
    end
  end

  def update_rinks
    schedule = Nokogiri::HTML(fetch_full_schedule)
    created = 0
    links = schedule.css(".pfrProgramDescrList.dropinbox h4 a")
    links.each do |link|
      rink_name = link.text.squish
      logger.info "Processing rink: #{rink_name}"
      rink = Rink.find_by_name(rink_name)
      if rink.nil?
        logger.info "\t=> Creating rink: #{rink_name}"
        Rink.create!(name: rink_name, url: HOST + link.attr("href"))
        created += 1
      end
    end
    logger.info "Processed #{links.size} rinks. Created #{created}"
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
        activity_name = row_cols[0].text.squish

        row.css("td")[1..-1].each_with_index do |cell, index|
          next if cell.text.blank?
          date = date_for_column_index[index]
          if date.nil?
            logger.warn "Do not have date for column index #{index}"
            next
          end

          start_time_of_day, end_time_of_day = begin
            @time_range_parser.parse(cell.text)
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

    schedule_entries
  end

  private

  def fetch_full_schedule
    @schedule_html ||= begin
      url = "#{HOST}/parks/prd/skating/dropin/hockey/"
      logger.info("Fetching schedule from #{url}")
      open(url){ |f| f.read }
    end
  end

  def logger
    Rails.logger
  end

end