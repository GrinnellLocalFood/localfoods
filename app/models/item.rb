class Item < ActiveRecord::Base
	belongs_to :inventory, :foreign_key => "inventory_id"
	has_attached_file :item_photo, :url => "/system/item_photos/:id/:style/:basename.:extension", :styles => {
		:thumb => "50x50>",
		:medium => "300x300>",
		:small => "150x150>"
	}

	attr_accessible :name, :description, :minorder, :maxorder, :item_photo ,:price, :available, :units

	validates :name, :presence => true
	validates :description, :presence => true
	validates :minorder, :presence => true
	validates :price, :presence => true
	validates :units, :presence => true
	validates :maxorder, :numericality => {:greater_than => :minorder}, :allow_blank => true

	before_validation :format_values


	def is_available?
		if self.available
			"Yes"
		else
			"No"
		end
	end

	private

	def format_values
		if(self.units.nil? || self.units.empty?)
			self.units = "units"
		end
		self.units.downcase
	end
end
