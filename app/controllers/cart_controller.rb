class CartController < ApplicationController
		#layout 'blank'
	layout 'blank', :only => :show_in_modal 

	def show
		@cart = current_cart
	end

	def show_in_modal
		@cart = current_cart
	end

end
