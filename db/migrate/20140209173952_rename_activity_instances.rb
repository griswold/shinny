class RenameActivityInstances < ActiveRecord::Migration
  def change
    rename_table :activity_instances, :scheduled_activities
  end
end
