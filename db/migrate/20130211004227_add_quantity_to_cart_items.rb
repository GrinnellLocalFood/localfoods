class AddQuantityToCartItems < ActiveRecord::Migration
   def self.up
  	add_column :cart_items, :quantity, :decimal, :precision => 10
  end

  def self.down
  	remove_column :cart_items, :quantity, :decimal
  end
end
