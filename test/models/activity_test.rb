require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  def test_recognizes_activities
    shinny = Activity.create! name: "Shinny"
    skate = Activity.create! name: "Public skate"
    assert_equal shinny, Activity.recognize("Shinny: all ages")
    assert_equal skate, Activity.recognize("Public skate")
  end

  def test_extract_workds
    assert_equal %w( shinny all ages ), Activity.extract_words("Shinny: all ages")
  end

end
