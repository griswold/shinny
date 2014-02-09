require 'test_helper'

class TimeRangeParserTest < ActiveSupport::TestCase

  def test_parse
    parser = TimeRangeParser.new
    [
      ["12:30 - 6pm", "12:30:00", "18:00:00"],
      ["8 - 10pm", "20:00:00", "22:00:00"],
      ["9am - 12pm", "09:00:00", "12:00:00"],
      ["9am - 10", "09:00:00", "10:00:00"],
      ["9am - 10pm", "09:00:00", "22:00:00"],
      ["19:00 - 21:00", "19:00:00", "21:00:00"],

    ].each do |input, start_time, end_time|
      result_start, result_end = parser.parse(input) 
      assert_equal [start_time, end_time].join("-"),
                   [result_start, result_end].join("-")
    end
  end
end
