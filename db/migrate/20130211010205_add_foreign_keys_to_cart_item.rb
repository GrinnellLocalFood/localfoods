class AddForeignKeysToCartItem < ActiveRecord::Migration
  def self.up
  	add_column :cart_items, :cart_id, :integer
  	add_column :cart_items, :item_id, :integer
  end

  def self.down
  	remove_column :cart_items, :cart_id, :integer
  	remove_column :cart_items, :item_id, :integer
  end
end
