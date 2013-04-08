class AddUniquenessToCategoryName < ActiveRecord::Migration
  def self.up
    add_index :categories, :name, :unique => true
  end

  def self.down
    remove_index :categories, :name
  end
end

