require "open-uri"

class Scraper

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
        Rink.create!(name: rink_name, url: link.attr("href"))
        created += 1
      end
    end
    logger.info "Processed #{links.size} rinks. Created #{created}"
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