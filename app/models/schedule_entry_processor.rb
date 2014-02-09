class ScheduleEntryProcessor

  FEMALE = /girls?|female|women/i
  MALE = /boys?|male|men/i

  def process(rink, entry)
    start_age, end_age = get_start_and_end_age(entry.label)
    activity = Activity.recognize(entry.label)

    ScheduledActivity.new rink: rink,
                          activity: activity,
                          start_age: start_age,
                          end_age: end_age,
                          original_label: entry.label,
                          gender: detect_gender(entry.label),
                          start_time: entry.start_time,
                          end_time: entry.end_time,
                          latitude: rink.latitude,
                          longitude: rink.longitude
  end

  private

  def detect_gender(label)
    if FEMALE.match(label)
      ScheduledActivity::FEMALE
    elsif MALE.match(label)
      ScheduledActivity::MALE
    else
      nil
    end
  end

  def get_start_and_end_age(label)
    matches = /(\d+).*?(\d+)/.match(label)
    matches && matches[1..2].compact.map(&:to_i)
  end

end
