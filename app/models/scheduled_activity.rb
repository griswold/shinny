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

  def self.search(start_time, end_time)
    where(end_time: start_time..end_time).order("start_time asc").limit(20).includes(:rink, :activity)
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
