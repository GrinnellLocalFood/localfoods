class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :user_id, :unique
      t.string :first_name
      t.string :last_name
      t.string :email, :unique
      t.string :phone
      t.string :password, :ssl_enabled
      t.string :display_name
      t.boolean :member, :default => true
      t.boolean :coordinator, :default => false
      t.boolean :farmer, :default => false
      t.boolean :admin, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
