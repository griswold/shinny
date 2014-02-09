class Rink < ActiveRecord::Base
  scope :ordered, order("name asc")
end
