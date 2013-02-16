class Inventory < ActiveRecord::Base
	attr_accessible :inventory_photos_attributes, :inventory_photos
	belongs_to :user, :foreign_key => "id" #a user's "id" column is the foreign key# :autosave => false 
	has_many :item, :foreign_key => "inventory_id", :autosave => true
	has_many :inventory_photos, :dependent => :destroy
	accepts_nested_attributes_for :inventory_photos

	has_attached_file :photo, :url => "/system/photos/:id/:style/:basename.:extension", :styles => {
		:large => "700x700>",
		:medium => "300x300>",
		:small => "150x150>",
		:index_thumb => "100x100>",
		:thumb => "60x60>"
	}
	before_photo_post_process :process_only_images
	attr_accessible :url, :description, :display_name, :photo
		validates :display_name, :presence => true, :if => "!self.hidden?"

	before_create :default_display_name
	accepts_nested_attributes_for :user
	#fake-delete an inventory so that it persists even if a user is no longer
	#a producer
	def hide
		self.hidden = true
	end

	private
	def process_only_images
		if !(photo.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
			return false
		end
	end

	def default_display_name
		self.display_name = self.user.first_name + " " + self.user.last_name 
	end
end

