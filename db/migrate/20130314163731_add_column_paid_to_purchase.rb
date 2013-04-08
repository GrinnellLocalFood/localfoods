class AddColumnPaidToPurchase < ActiveRecord::Migration
  def self.up
    add_column :purchases, :paid, :boolean, :default => false
  end

  def self.down
    remove_index :purchases, :paid
  end
end
