require "open-uri"

class Scraper

  def update_rinks
    schedule = Nokogiri::HTML(fetch_full_schedule)
    changed = 0
    schedule.css(".pfrProgramDescrList.dropinbox h4 a").each do |link|
      rink_name = link.text.squish
      logger.info "Processing rink: #{rink_name}"
      rink = Rink.find_by_name(rink_name)
      if rink.nil?
        logger.info "\t=> Creating rink: #{rink_name}"
        Rink.create!(name: rink_name, url: link.attr("href"))
        changed += 1
      end
    end
    puts "Created #{changed} rinks"
  end

  private

  def fetch_full_schedule
    @schedule_html ||= begin
      url = "http://www1.toronto.ca/parks/prd/skating/dropin/hockey/"
      logger.info("Fetching schedule from #{url}")
      open(url){ |f| f.read }
    end
  end

  def logger
    Rails.logger
  end

end