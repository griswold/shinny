class ScheduledActivity < ActiveRecord::Base

  MALE = "M"
  FEMALE = "F"

  belongs_to :activity
  belongs_to :rink

  validates :gender, inclusion: { in: [MALE, FEMALE, nil] }
  validates :activity, :rink, :start_time, :end_time, presence: true
  before_save :denormalize_lat_lon

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

  private

  def denormalize_lat_lon
    if rink
      self.latitude = rink.latitude
      self.longitude = rink.longitude
    end
  end

end
