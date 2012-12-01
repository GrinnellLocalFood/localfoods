class Inventory < ActiveRecord::Base
	belongs_to :user, :foreign_key => "id" #a user's "id" column is the foreign key# :autosave => false 
	has_many :item, :foreign_key => "inventory_id", :autosave => true

	has_attached_file :photo, :url => "/public/system/photos/:id/:style/:basename.:extension", :styles => {
		:large => "700x700>",
		:medium => "300x300>",
		:small => "150x150>"
	}
	before_photo_post_process :process_only_images
	attr_accessible :url, :description, :display_name, :photo
	private
	def process_only_images
		if !(photo.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
			return false
		end
	end
end
