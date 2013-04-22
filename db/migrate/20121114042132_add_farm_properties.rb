class AddFarmProperties < ActiveRecord::Migration
  def self.up
  	add_column :farms, :description, :string
        add_column :farms, :url, :string
  end

  def self.down
  	remove_column :farms, :url
        remove_column :farms, :description
  end
end
