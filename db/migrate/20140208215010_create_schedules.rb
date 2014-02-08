class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :rink_id
      t.integer :activity_id
      t.integer :age_group_id
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
