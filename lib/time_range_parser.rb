class TimeRangeParser

  BOUNDARY_REGEX = /(\d\d?)(?:\:(\d\d))?\s*(am|pm)?/
  RANGE_REGEX = /#{BOUNDARY_REGEX}\s*\-\s*#{BOUNDARY_REGEX}/

  def parse(time_range)
    cleansed = time_range.squish.downcase
    matches = RANGE_REGEX.match(time_range)
    raise ArgumentError.new("invalid range input: #{time_range}") unless matches

    start_hour, start_minute, start_period, end_hour, end_minute, end_period = matches[1..-1]

    start_24_hour, end_24_hour = if start_period.nil? && end_period.nil?
      [start_hour, end_hour]
    else
      start_period ||= end_period
      end_period ||= start_period
      [hour_to_military(start_hour, start_period), hour_to_military(end_hour, end_period)]
    end

    [format(start_24_hour, start_minute),
     format(end_24_hour, end_minute)]
  end

  private

  def hour_to_military(hour, period)
    hour = hour.to_i
    if "am" == period && hour == 12
      0
    elsif "pm" == period && hour != 12
      hour + 12
    else
      hour
    end
  end

  def format(hour, minute)
    "%02d:%02d:00" % [hour || 0, minute || 0]
  end

end
