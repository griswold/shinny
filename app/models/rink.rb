class Rink < ActiveRecord::Base
  scope :ordered, -> { order("name asc") }
  has_many :scheduled_activities
end
