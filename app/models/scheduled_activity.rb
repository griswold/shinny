class ScheduledActivity < ActiveRecord::Base

  MALE = "M"
  FEMALE = "F"

  belongs_to :activity
  belongs_to :rink

  validates :gender, inclusion: { in: [MALE, FEMALE, nil] }
  validates :activity, :rink, :start_time, :end_time, presence: true

  def self.conflict_exists?(activity)
    where(rink: activity.rink, start_time: activity.start_time..activity.end_time).any?
  end

  def gender_text
    { MALE => "Male only", FEMALE => "Female only" }[gender]
  end

  def age_range
    if start_age && end_age
      [start_age, end_age].join(" - ")
    elsif start_age
      "#{start_age}+"
    elsif end_age
      "Up to #{end_age}"
    else
      nil
    end
  end

end
