class ChangeUnitsFromIntegerToString < ActiveRecord::Migration
  def self.up
  	change_column :items, :units, :string
  end

  def self.down
  	change_column :items, :units, :integer
  end
end
