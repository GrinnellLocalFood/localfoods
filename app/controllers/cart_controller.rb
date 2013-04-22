class CartController < ApplicationController
		#layout 'blank'
	layout 'blank', :only => :show_in_modal 

	def show
		@cart = current_cart
	end

	def show_in_modal
		@cart = current_cart
	end

	def cart_size
		@cart_size = current_user.cart.cart_items.size
	end

end
