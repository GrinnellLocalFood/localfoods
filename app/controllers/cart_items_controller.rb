class CartItemsController < ApplicationController
	def create
		@item = Item.find(params[:item_id])
		@cart_item = CartItem.where("cart_id = ? AND item_id = ?", current_user.cart, @item).first
		if @cart_item.nil?
			@cart_item = CartItem.create!(:cart_id => current_user.cart.id, :quantity => 1.0, :item_id => @item.id)
			flash[:notice] = "Added #{@item.name} to cart"
		else
			@cart_item.quantity = @cart_item.quantity + 1.0
			@cart_item.save
			flash[:notice] = "Updated #{@item.name} in cart"
		end

		redirect_to url_for :controller => 'cart', :action => 'show', :id => current_user.cart
	end

	def destroy
		@item = CartItem.find(params[:id])
		@item.destroy
		respond_to do |format|
        	format.html { redirect_to(cart_path(current_user)) }
        	format.xml  { head :ok }
    	end
	end

	def update
		@cart_item = CartItem.find(params[:cart_item_id])
		respond_to do |format|
			if @cart_item.update_attributes(params[:cart_item])
				format.html { redirect_to(cart_path(params[:id], :item => @cart_item.id, :disable => true), :notice => 'Item was successfully updated.') }
				format.xml  { head :ok }       
			else
				format.html { redirect_to(cart_path(params[:id]), :error => 'Item was not successfully updated.') }
				format.xml  { render :xml => @cart_item.errors, :status => :unprocessable_entity }
			end
		end
	end
end
