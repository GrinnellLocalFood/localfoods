class PurchasesController < ApplicationController
	
	def new
		@purchase = Purchase.new
	end

	def create
		current_cart = current_user.cart
		current_cart.cart_items.each do |cart_item|
			@old_purchase = Purchase.where("user_id =? AND item_id = ?", current_user.id, cart_item.item.id).first
			if @old_purchase.nil?
				@purchase = Purchase.new(:item_id => cart_item.item_id, 
							 :user_id => current_user.id, 
							 :quantity => cart_item.quantity,
							 :unit_price => cart_item.item.price)
				if !@purchase.save
					render "error"
					errored_out = true
				end
			else
				@old_purchase.quantity += cart_item.quantity

				if !@old_purchase.save
					render "error"
				end
			end
		end

		current_cart.clear_all_items
		redirect_to :action => 'index'
	end

	def index
		@title = "Order History"
		@purchases = Purchase.where("user_id = ?", current_user.id)
	end

	def all_orders
		@title = "All Orders"
		@purchases = Purchase.all
	end
end
