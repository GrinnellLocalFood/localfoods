class PaymentNotification < ActiveRecord::Base
  attr_accessible :cart_id, :params, :status, :transaction

  belongs_to :cart
  serialize :params
  after_create :create_purchases


	def create_purchases

		if(status == "Completed")
			current_cart = Cart.find(cart_id)
			current_cart.cart_items.each do |cart_item|
				@old_purchase = Purchase.where("user_id =? AND item_id = ?", current_cart.user.id, cart_item.item.id).first
				if @old_purchase.nil? || @old_purchase.paid == false
					@purchase = Purchase.new(:item_id => cart_item.item_id, 
							 :user_id => current_cart.user.id, 
							 :quantity => cart_item.quantity,
							 :unit_price => cart_item.item.price,
							 :paid => true)
					@purchase.save
				else
					@old_purchase.quantity += cart_item.quantity
					@old_purchase.save
				end
			end
			current_cart.clear_all_items
		end
	end

end
