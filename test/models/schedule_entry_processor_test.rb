require 'test_helper'

class ScheduleEntryProcessorTest < ActiveSupport::TestCase

  def setup
    @under_test = ScheduleEntryProcessor.new
    @rink = Rink.new.tap{ |r| r.id = 1}
  end

  def test_age_groups
    sa = @under_test.process(@rink, entry("Shinny (13 - 18yrs)"))
    assert_equal 13, sa.start_age
    assert_equal 18, sa.end_age
  end

  def test_no_age_group
    sa = @under_test.process(@rink, entry("Shinny (boys only)"))
    assert_nil sa.start_age
    assert_nil sa.end_age
  end

  def test_gender
    sa = @under_test.process(@rink, entry("Shinny (Boys only)"))
    assert_equal ScheduledActivity::MALE, sa.gender
  end

  def test_gender
    sa = @under_test.process(@rink, entry("Shinny (13 - 22yrs)"))
    assert_nil sa.gender
  end

  def test_max_age
    sa = @under_test.process(@rink, entry("Shinny: Caregiver & Child (up to 8yrs)"))
    assert_nil sa.start_age
    assert_equal 8, sa.end_age
  end

  private

  def entry(label, start_time=Time.now, end_time=Time.now)
    ScheduleEntry.new(label, start_time, end_time)
  end

end