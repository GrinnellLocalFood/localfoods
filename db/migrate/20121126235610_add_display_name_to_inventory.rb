class AddDisplayNameToInventory < ActiveRecord::Migration
  def self.up
  	add_column :inventories, :display_name, :string
  end

  def self.down
  	remove_column :inventories, :display_name
  end
end
