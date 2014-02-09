class ActivityInstance < ActiveRecord::Base
  belongs_to :activity
  belongs_to :rink
  belongs_to :age_group
end
