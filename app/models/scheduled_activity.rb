class ScheduledActivity < ActiveRecord::Base
  MALE = "M"
  FEMALE = "F"

  belongs_to :activity
  belongs_to :rink
  belongs_to :age_group

  validates :gender, inclusion: { in: [MALE, FEMALE, nil] }
  validates :activity, :rink, :start_time, :end_time, presence: true

  def self.conflict_exists?(activity)
    where(rink: activity.rink, start_time: activity.start_time..activity.end_time).any?
  end
end
