class AddFarmProperties < ActiveRecord::Migration
  def self.up
  	add_column :farms,:description
        add_column, :farms, :url
  end

  def self.down
  	remove_column :farms, :url
        remove_column :farms, :description
  end
end
