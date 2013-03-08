class CartItem < ActiveRecord::Base
 	belongs_to :cart
 	belongs_to :item
 	validates :cart_id, :presence => true
  	validates :item_id, :presence => true
  	validates_presence_of :quantity, :message => "must be greater than Minorder for the item",
  						 :if => Proc.new { |a| a.item.minorder < a.quantity }

 	attr_accessible :quantity,
 					:cart_id,
 					:item_id

 	def full_price
 		item.price * quantity
 	end
end
