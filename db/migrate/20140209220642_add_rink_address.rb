class AddRinkAddress < ActiveRecord::Migration
  def change
    add_column :rinks, :address, :string
  end
end
