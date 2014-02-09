class AddAgesToScheduledActivities < ActiveRecord::Migration
  def change
    remove_column :scheduled_activities, :age_group_id
    add_column :scheduled_activities, :start_age, :integer
    add_column :scheduled_activities, :end_age, :integer
  end
end
