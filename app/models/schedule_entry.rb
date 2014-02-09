class ScheduleEntry < Struct.new(:label, :start_time, :end_time)
  def to_s
    %Q(#{label.inspect}: #{start_time.strftime("%Y-%m-%d %H:%M:%S")} - #{end_time.strftime("%Y-%m-%d %H:%M:%S")})
  end
end
