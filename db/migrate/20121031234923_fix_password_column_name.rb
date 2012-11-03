class FixPasswordColumnName < ActiveRecord::Migration
  def self.up
  	rename_column :users, :password, :encrypted_password
  end

  def self.down
  	rename_column :users, :encrypted_password, :password
  end
end
