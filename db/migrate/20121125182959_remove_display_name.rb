class RemoveDisplayName < ActiveRecord::Migration
  def self.up
  	remove_column :users, :display_name
  end

  def self.down
  	add_column :users, :display_name
  end
end
