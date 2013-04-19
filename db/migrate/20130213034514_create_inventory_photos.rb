class CreateInventoryPhotos < ActiveRecord::Migration
  def change
    create_table :inventory_photos do |t|

      t.timestamps
    end
  end
end
