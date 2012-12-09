class CreateItemPhotos < ActiveRecord::Migration
  def self.up
    create_table :item_photos do |t|
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :item_photos
  end
end
