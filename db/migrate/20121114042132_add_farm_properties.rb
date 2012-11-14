class AddFarmProperties < ActiveRecord::Migration
  def self.up
  	add_column :farms, :description, :url
  end

  def self.down
  	remove_column :farms, :description
  end
end
