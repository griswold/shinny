class RenameSchedulesToActivityInstances < ActiveRecord::Migration
  def change
    rename_table :schedules, :activity_instances
  end
end
