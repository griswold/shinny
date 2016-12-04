require 'test_helper'

class TorontoCityRinkScraperTest < ActiveSupport::TestCase

  def setup
    @scraper = TorontoCityRinkScraper.new
  end

  def test_extract_schedule_entries
    entries = @scraper.extract_schedule_entries(rink_activity_table)
    assert_contains_entry "Public Skate", "2016-12-07 16:30:00", "2016-12-07 18:00:00", entries
    assert_contains_entry "Older Adult Skate (60yrs and over)", "2016-12-06 10:00:00", "2016-12-06 12:00:00", entries
  end

  def test_handles_multiple_times_in_one_cell
    entries = @scraper.extract_schedule_entries(rink_activity_table)
    assert_contains_entry "Public Skate", "2014-02-12 09:00:00", "2014-02-12 12:00:00", entries
    assert_contains_entry "Public Skate", "2014-02-12 15:00:00", "2014-02-12 17:00:00", entries
  end

  private

  def rink_detail_page
    @rink_detail_page ||= IO.read(File.expand_path("rink_detail.html", File.dirname(__FILE__)))
  end

  def rink_activity_table
    Nokogiri::HTML(rink_detail_page).css("#pfrComplexTabs-dropin").to_html
  end

  def assert_contains_entry(name, start_time_str, end_time_str, schedule_entries)
    start_time = Time.parse(start_time_str)
    end_time = Time.parse(end_time_str)
    entry = ScheduleEntry.new(name, start_time, end_time)
    matches = schedule_entries.include?(entry)
    entries_with_same_label = schedule_entries.select{ |e| entry.label == e.label }.sort_by(&:start_time)
    assert matches, <<-EOD
      Expected to find entry matching #{entry} but didn't.
      Entries with same label:\n\t#{entries_with_same_label.map(&:to_s).join("\n\t")}
    EOD
  end

end
