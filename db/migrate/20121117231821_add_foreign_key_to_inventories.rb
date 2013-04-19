class AddForeignKeyToInventories < ActiveRecord::Migration
  def self.up
  	add_column :inventories, :farm_id, :integer
  end

  def self.down
  	remove_column :inventories, :farm_id, :integer
  end
end
