class RenameInventoriesToItem < ActiveRecord::Migration
  def self.up
  	rename_table :inventories, :items
  end

  def self.down
  	rename_table :items, :inventories
  end
end
