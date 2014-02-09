class DropAgeGroups < ActiveRecord::Migration
  def change
    drop_table :age_groups
  end
end
