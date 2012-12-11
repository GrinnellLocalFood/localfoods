class ProducerDescriptionStringToText < ActiveRecord::Migration
  def self.up
	change_column :inventories, :description, :text
  end

  def self.down
	change_column :inventories, :description, :string	
  end
end
