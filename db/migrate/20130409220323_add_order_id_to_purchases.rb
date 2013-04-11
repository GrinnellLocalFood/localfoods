class AddOrderIdToPurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :order_set, :string
  end

  def self.down
    remove_index :purchases, :order_set, :string
  end
end

