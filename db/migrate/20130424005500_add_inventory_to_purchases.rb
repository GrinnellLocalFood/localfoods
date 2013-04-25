class AddInventoryToPurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :inventory_id, :integer
  end

  def self.down
    remove_index :purchases, :inventory_id, :integer
  end
end
