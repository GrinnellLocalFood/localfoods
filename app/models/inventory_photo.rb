class InventoryPhoto < ActiveRecord::Base	
  belongs_to :inventory, :autosave => true, :dependent => :destroy
  attr_accessible :photo, :photo_attributes
  accepts_nested_attributes_for :inventory, :allow_destroy => true
  has_attached_file :photo, :url => "/system/inventory_photos/:id/:style/:basename.:extension", :styles => {
		:gallery_size => "450x300",
		:thumb => "45X30"

	}
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validate :file_dimensions, :unless => "errors.any?"
  
  def file_dimensions
  dimensions = Paperclip::Geometry.from_file(photo.queued_for_write[:original].path)
  if dimensions.width < 450 || dimensions.height < 300
    errors.add(:photo,'Width or height must be at least 50px')
  end
end

end
