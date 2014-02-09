require 'test_helper'

class ScraperTest < ActiveSupport::TestCase

  def setup
    @scraper = Scraper.new
  end

  def test_extract_schedule_entries
    entries = @scraper.extract_schedule_entries(rink_activity_table)
    entries.each do |entry|
      puts entry
    end
    assert_contains_instance "Public Skate", "2014-02-09 14:30:00", "2014-02-09 18:00:00", entries
    assert_contains_instance "Shinny: Girls", "2014-02-14 17:00:00", "2014-02-14 18:00:00", entries
  end

  def test_handles_multiple_times_in_one_cell
    entries = @scraper.extract_schedule_entries(rink_activity_table)
    entries.each do |entry|
      puts entry
    end
    assert_contains_instance "Public Skate", "2014-02-12 09:00:00", "2014-02-12 12:00:00", entries
    assert_contains_instance "Public Skate", "2014-02-12 15:00:00", "2014-02-12 17:00:00", entries
  end

  private

  def rink_detail_page
    @rink_detail_page ||= IO.read(File.expand_path("rink_detail.html", File.dirname(__FILE__)))
  end

  def rink_activity_table
    Nokogiri::HTML(rink_detail_page).css("#pfrComplexTabs-dropin").to_html
  end

  def assert_contains_instance(name, start_time_str, end_time_str, schedule_entries)
    start_time = Time.parse(start_time_str)
    end_time = Time.parse(end_time_str)
    matches = schedule_entries.any? do |se|
      se.label == name &&
      se.start_time == strftime(start_time) &&
      se.end_time == strftime(end_time)
    end
    assert matches, "Expected to find #{name} from #{start_time_str} to #{end_time_str} but didn't!"
  end

  def strftime(time)
    time.strftime("%Y%mm%dd %HH:%MM:%SS")
  end

end
