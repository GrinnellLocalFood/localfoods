class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :password
      t.string :display_name
      t.boolean :member
      t.boolean :coordinator
      t.boolean :farmer
      t.boolean :admin

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
