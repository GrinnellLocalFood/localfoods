class RenameFarmerToProducer < ActiveRecord::Migration
  def self.up
  	rename_column :users, :farmer, :producer
  end

  def self.down
  	rename_column :users, :producer, :farmer
  end
end
