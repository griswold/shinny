module ApplicationHelper
  def format_activity_time(start_time, end_time)
    time_of_day_format = "%-I:%M%P"
    start_format = [("%b %-d" unless start_time.to_date == Date.today), time_of_day_format].compact.join(" ")
    [start_time.strftime(start_format), "-", end_time.strftime(time_of_day_format)].join(" ")
  end

  def summarize_search(search)
    ["Showing #{search.activity.name.downcase}"].tap do |msg|
      if search.age.blank? && search.gender.blank?
        msg << "for everyone"
      else
        msg << "for a "
        msg << "#{search.age} year old" if search.age.present?
        gender = { ScheduledActivity::MALE => "guy", ScheduledActivity::FEMALE => "girl" }[search.gender]
        msg << gender if gender.present?
      end
      msg << (search.distance.present? ? "within #{search.distance}km of" : "near")
      msg << search.location
    end.join(" ")
  end
end
