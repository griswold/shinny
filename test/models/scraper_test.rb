require 'test_helper'

class ScraperTest < ActiveSupport::TestCase

  def setup
    @scraper = Scraper.new
  end

  def test_extract_schedule_entries
    schedule_entries = @scraper.extract_schedule_entries(rink_activity_table)
    schedule_entries.each do |entry|
      puts entry
    end
    assert_contains_instance "Public Skate", "2014-02-09 14:30:00", "2014-02-09 18:00:00", instances
  end

  private

  def rink_detail_page
    @rink_detail_page ||= IO.read(File.expand_path("rink_detail.html", File.dirname(__FILE__)))
  end

  def rink_activity_table
    Nokogiri::HTML(rink_detail_page).css("#pfrComplexTabs-dropin").to_html
  end

  def assert_contains_instance(name, start_time_str, end_time_str, activity_instances)
    start_time = Time.parse(start_time_str)
    end_time = Time.parse(end_time_str)
    matches = activity_instances.any? do |ai|
      ai.activity.name == name &&
      ai.start == start_time &&
      ai.end == end_time
    end
    assert matches, "Expected to find #{name} from #{start_time_str} to #{end_time_str} but didn't!"
  end

end
