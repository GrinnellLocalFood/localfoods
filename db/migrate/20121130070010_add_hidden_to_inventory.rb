class AddHiddenToInventory < ActiveRecord::Migration
  def self.up
  	add_column :inventories, :hidden, :boolean, { :default => false }
  end

  def self.down
  	remove_column :inventories, :hidden
  end
end
