class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :quantity
      t.decimal :unit_price

      t.timestamps
    end
  end
end
