class CreateGeocodings < ActiveRecord::Migration
  def change
    create_table :geocodings do |t|
      t.string :text
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
    add_index :geocodings, :text, unique: true
  end
end
