class RenameFarmToInventory < ActiveRecord::Migration
  def self.up
  	rename_column :items, :farm_id, :inventory_id
  	rename_table :farms, :inventories
  end

  def self.down
  	rename_table :inventories, :farms
  	rename_column :items, :inventory_id, :farm_id
  end
end
