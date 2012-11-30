class Item < ActiveRecord::Base
	belongs_to :inventory, :foreign_key => "inventory_id"
	has_attached_file :item_photo

	attr_accessible :name, :description, :minorder, :maxorder, :item_photo ,:price, :available, :units

	def is_available?(item)
		if item.available
			"Yes"
		else
			"No"
		end
	end
end
