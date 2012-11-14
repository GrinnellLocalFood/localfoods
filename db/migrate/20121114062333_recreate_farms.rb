class RecreateFarms < ActiveRecord::Migration
   def self.up
    create_table :farms do |t|

      t.timestamps
    end
    add_column :farms, :url, :string
    add_column :farms, :description, :string
  end

  def self.down
    drop_table :farms
  end
end
