module ApplicationHelper
  def format_activity_time(start_time, end_time)
    time_of_day_format = "%-I:%M%P"
    start_format = [("%b %-d" unless start_time.to_date == Date.today), time_of_day_format].compact.join(" ")
    [start_time.strftime(start_format), "-", end_time.strftime(time_of_day_format)].join(" ")
  end
end
