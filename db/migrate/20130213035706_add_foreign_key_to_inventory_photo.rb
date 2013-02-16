class AddForeignKeyToInventoryPhoto < ActiveRecord::Migration
  def self.up
  	add_column :inventory_photos, :inventory_id, :integer
  end

  def self.down
  	remove_column :inventory_photos, :inventory_id
  end
end
