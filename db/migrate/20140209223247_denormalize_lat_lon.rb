class DenormalizeLatLon < ActiveRecord::Migration
  def change
    add_column :scheduled_activities, :latitude, :decimal
    add_column :scheduled_activities, :longitude, :decimal
  end
end
