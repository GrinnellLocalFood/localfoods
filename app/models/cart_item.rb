class CartItem < ActiveRecord::Base
 	belongs_to :cart
 	belongs_to :item

 	attr_accessible :quantity,
 					:cart_id,
 					:item_id

 	def full_price
 		item.price * quantity
 	end
end
