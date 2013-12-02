class Item < ActiveRecord::Base
	belongs_to :inventory, :foreign_key => "inventory_id"
	belongs_to :category, :foreign_key => "category_id"
	has_attached_file :item_photo, :url => "/system/item_photos/:id/:style/:basename.:extension", :styles => {
		:thumb => "50x50#",
		:grid => "75x75#",
		:medium => "300x300>",
		:small => "150x150>"
	}
	attr_accessible :name, :description, :totalquantity, :minorder, :maxorder, :item_photo ,:price, :available, :units, :category_id, :inventory_id

	validates :name, :presence => true
	validates :minorder, :presence => true, :numericality => { :only_integer => true }
	validates :price, :presence => true
	validates :units, :presence => true, :format => { :with => /[a-zA-Z.\s]/, :message => "cannot contain special or numeric characters." }
	validates :totalquantity, :presence => true, :numericality => { :only_integer => true }
	validates :maxorder, :numericality => {:only_integer => true}, :allow_blank => true
	validates :maxorder, :numericality => {:greater_than_or_equal_to => :minorder, :message => "must be greater than Minorder"}, :allow_blank => true
	validates :category_id, :presence => true
	before_validation :format_values

   searchable do
    text :name
    text :inventory do inventory.display_name end
    text :inventory_description do inventory.description end
    text :category  do category.name end
    text :description
    string :name
   	string :category do
   		category.name
   	end
   	string :inventory do
   	    inventory.display_name
   	end
   	float :price
   end

	def is_available?
		if ApplicationState.orders_open?
			if num_remaining < minorder
				"Sold Out"
			elsif self.available
				"Yes"
			else
				"No"
			end
		else
			"No"
		end
	end

	def cartable?
		num_remaining > minorder && ApplicationState.orders_open? && self.available
	end

	def displayed_maxorder
		if self.maxorder.blank?
			"None"
		else
			self.maxorder
		end
	end

	def num_remaining
		totalquantity - totalordered
	end

	def markup_price
		return BigDecimal.new((1.1 * price).to_s).round(2)
	end

	private

		def format_values
			if(self.description.nil?)
				self.description = ""
			end
			
			if(self.units.nil? || self.units.empty?)
				self.units = "units"
			end
			self.units = self.units.downcase
		end

		def order(quantity)
			if (ApplicationState.orders_open? && (available && valid_quantity?(quantity)))
				self.totalordered += quantity
			end
		end

		def valid_quantity?(quantity)
			(quantity >= minorder) && (quantity <= maxorder) && (quantity <= self.num_remaining)
		end

		def update_availability
			self.available = (self.num_remaining >= minorder)
	  		#must return true because before_save cancels save if this method returns false
	  		return true
		end


		def reset_quantity
			self.totalordered = 0
			self.available = true
		end

		

end
