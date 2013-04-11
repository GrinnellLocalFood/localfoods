class PurchasesController < ApplicationController
	
	def new
		@purchase = Purchase.new
	end

	def create
		Purchase.create_purchases(current_user.cart, false, nil)
		redirect_to :action => 'index'
	end		

	def index
		@title = "Order History"
		@orders = Purchase.where("user_id = ?", current_user.id).uniq.pluck(:order_set)

		if @orders.include?("unpaid")
			@orders.delete("unpaid")
			@orders << "unpaid"
		end
	end

	def all_orders
		@title = "All Orders"
		@purchases = Purchase.all
	end

	def process_order
		redirect_to :action => 'index'
	end
end
