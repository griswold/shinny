class ChangeScheduledActivities < ActiveRecord::Migration
  def change
    rename_column :scheduled_activities, :start, :start_time
    rename_column :scheduled_activities, :end, :end_time
    add_index :scheduled_activities, :start_time
  end
end
