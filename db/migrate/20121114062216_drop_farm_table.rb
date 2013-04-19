class DropFarmTable < ActiveRecord::Migration
  def self.up
  	drop_table :farms
  end

  def self.down
  	create_table :farms
  end
end
