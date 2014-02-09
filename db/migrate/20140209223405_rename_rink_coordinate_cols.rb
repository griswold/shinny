class RenameRinkCoordinateCols < ActiveRecord::Migration
  def change
    rename_column :rinks, :lat, :latitude
    rename_column :rinks, :lon, :longitude
  end
end
