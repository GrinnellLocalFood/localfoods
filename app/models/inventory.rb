class Inventory < ActiveRecord::Base
	attr_accessor :category
	attr_accessible :inventory_photos_attributes, :inventory_photos, :category
	belongs_to :user, :foreign_key => "id" #a user's "id" column is the foreign key# :autosave => false 
	has_many :item, :foreign_key => "inventory_id", :autosave => true, :dependent => :destroy
	has_many :inventory_photos, :dependent => :destroy
	has_many :purchases, :foreign_key => "inventory_id"
	accepts_nested_attributes_for :inventory_photos
	
	accepts_nested_attributes_for :item, :reject_if => proc { |a| a['name'].blank? || a['name'].nil?}
	attr_accessible :url, :description, :display_name, :photo, :item, :item_attributes
	validates :display_name, :presence => true, :if => "!self.hidden?"

	before_create :default_display_name
	accepts_nested_attributes_for :user
	#fake-delete an inventory so that it persists even if a user is no longer
	#a producer
  
	def hide
		self.hidden = true
	end

	def categories
		Item.where("inventory_id = ?", id).uniq.pluck(:category_id).map{ |id| Category.find(id) }.sort! { |x,y| x.name <=> y.name }
	end

	def total_payment
    	total = 0.0
    	Purchase.where("inventory_id = ? ", id).each do |purchase|
      	total += purchase.full_price
    	end
    	return total
  	end

	private
	def default_display_name
		self.display_name = self.user.first_name + " " + self.user.last_name 
	end
end

