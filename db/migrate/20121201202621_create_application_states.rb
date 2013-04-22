class CreateApplicationStates < ActiveRecord::Migration
  def self.up
    create_table :application_states do |t|
      t.boolean :orders_open, :default => :false
      t.timestamps
    end
  end

  def self.down
    drop_table :application_states
  end
end
