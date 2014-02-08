class CreateRinks < ActiveRecord::Migration
  def change
    create_table :rinks do |t|
      t.string :name
      t.decimal :lat
      t.decimal :lon
      t.string :url

      t.timestamps
    end
    add_index :rinks, :name, unique: true
  end
end
