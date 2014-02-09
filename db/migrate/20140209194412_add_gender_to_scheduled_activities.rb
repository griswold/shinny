class AddGenderToScheduledActivities < ActiveRecord::Migration
  def change
    add_column :scheduled_activities, :gender, :string
  end
end
