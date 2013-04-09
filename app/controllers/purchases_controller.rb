class PurchasesController < ApplicationController
	
	def new
		@purchase = Purchase.new
	end

	def create
		Purchase.create_purchases(current_user.cart, false)
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

	def process_order
		redirect_to :action => 'index'
	end
end
