class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.int :rink_id
      t.int :activity_id
      t.int :age_group_id
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
