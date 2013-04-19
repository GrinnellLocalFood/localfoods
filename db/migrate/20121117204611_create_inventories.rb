class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
      t.string :name
      t.boolean :available, :default => false
      t.integer :units
      t.decimal :price, :precision => 10, :scale => 2
      t.integer :minorder, :default => 1
      t.integer :maxorder
      t.integer :totalquantity, :default => 0
      t.integer :totalordered, :default => 0
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :inventories
  end
end
