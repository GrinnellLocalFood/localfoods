class AddScaleToCartItemQuantity < ActiveRecord::Migration
  def self.up
  	change_column :cart_items, :quantity, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  	change_column :cart_items, :quantity, :decimal, :precision => 10
  end
end
