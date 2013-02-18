class InventoryPhoto < ActiveRecord::Base	
  belongs_to :inventory, :autosave => true
  attr_accessible :photo, :photo_attributes
  accepts_nested_attributes_for :inventory, :allow_destroy => true
  has_attached_file :photo, :url => "/system/inventory_photos/:id/:style/:basename.:extension", :styles => {
		:gallery_size => "450x300",
		:thumb => "45X30"

	}
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => '/image/', 
    :message => "This file does not have an accepted image extension."
  before_photo_post_process :process_only_images
  validate :file_dimensions, :unless => "errors.any?"
  

  def file_dimensions
  dimensions = Paperclip::Geometry.from_file(photo.queued_for_write[:original].path)
  if dimensions.width < 450 || dimensions.height < 300
    errors.add(:photo,'Width must be at least 450px and height must be at least 300px')
  end
 end

 private
  def process_only_images
    if !(photo.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
      return false
    end
  end

end
