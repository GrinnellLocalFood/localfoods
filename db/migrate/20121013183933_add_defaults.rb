class AddDefaults < ActiveRecord::Migration
  def self.up
  	change_column :users, :member, :boolean, { :default => true }
  	change_column :users, :coordinator, :boolean, { :default => false }
  	change_column :users, :farmer, :boolean, { :default => false }
  	change_column :users, :admin, :boolean, { :default => false }
  end

  def self.down
  	change_column :users, :member, :boolean
  	change_column :users, :coordinator, :boolean
  	change_column :users, :farmer, :boolean
  	change_column :users, :admin, :boolean
  end
end
