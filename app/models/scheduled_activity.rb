class ScheduledActivity < ActiveRecord::Base

  MALE = "M"
  FEMALE = "F"

  belongs_to :activity
  belongs_to :rink

  validates :gender, inclusion: { in: [MALE, FEMALE, nil] }
  validates :activity, :rink, :start_time, :end_time, presence: true

  geocoded_by :address

  def self.conflict_exists?(activity)
    where(rink: activity.rink, start_time: activity.start_time..activity.end_time, original_label: activity.original_label).any?
  end

  def address
    rink.address
  end

  def to_s
    "#{activity.name} @ #{rink.name} : #{start_time} - #{end_time}"
  end

end
