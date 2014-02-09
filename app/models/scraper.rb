require "open-uri"

class Scraper

  HOST = "http://www1.toronto.ca"

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

  def extract_activity_instances(activity_table_html)
    doc = Nokogiri::HTML(activity_table_html)
    schedule_tables = doc.css('tr[id^="dropin_Skating_"] table')

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
          puts "#{activity_name}: #{cell.text.squish}"
        end
      end
    end



    []
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