class MakeQuantityForCartItemInteger < ActiveRecord::Migration
    def self.up
  	change_column :cart_items, :quantity, :integer
  end

  def self.down
  	change_column :cart_items, :quantity, :decimal
  end
end
