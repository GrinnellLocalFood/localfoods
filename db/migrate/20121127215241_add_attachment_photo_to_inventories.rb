class AddAttachmentPhotoToInventories < ActiveRecord::Migration
  def self.up
    change_table :inventories do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :inventories, :photo
  end
end
