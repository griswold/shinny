class ScheduledActivity < ActiveRecord::Base
  MALE = "M"
  FEMALE = "F"

  belongs_to :activity
  belongs_to :rink
  belongs_to :age_group

  validates :gender, inclusion: { in: [MALE, FEMALE] }
  validates :activity, :rink, presence: true
end
