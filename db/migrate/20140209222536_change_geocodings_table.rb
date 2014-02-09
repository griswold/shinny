class ChangeGeocodingsTable < ActiveRecord::Migration
  def change
    rename_table :geocodings, :cached_geocodings
    add_column :cached_geocodings, :response, :text
    remove_column :cached_geocodings, :latitude
    remove_column :cached_geocodings, :longitude
  end
end
