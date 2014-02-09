class AddUniqueIndices < ActiveRecord::Migration
  def change
    add_index :activities, :name, unique: true
    add_index :age_groups, :name, unique: true
  end
end
