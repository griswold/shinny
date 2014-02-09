class AddOriginalLabelToScheduledActivities < ActiveRecord::Migration
  def change
    add_column :scheduled_activities, :original_label, :string
  end
end
