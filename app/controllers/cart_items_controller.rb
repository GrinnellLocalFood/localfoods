class CartItemsController < ApplicationController
	
	def create
		@item = Item.find(params[:item_id])
	 	@cart_item = CartItem.where("cart_id = ? AND item_id = ?", current_user.cart, @item).first
		if @cart_item.nil?
			@cart_item = CartItem.create!(:cart_id => current_user.cart.id, :quantity => @item.minorder, :item_id => @item.id)
			if @item.minorder > 1
			flash[:notice] = "Added #(@item.minorder} #{@item.name.pluralize} to cart"
			else
			flash[:notice] = "Added #{@item.name} to cart"
		end
		else
			@cart_item.quantity = @cart_item.quantity + 1
			if @cart_item.save
				flash[:notice] = "Updated #{@item.name} in cart"
			end
		end

		
		# redirect_to url_for :controller => 'cart', :action => 'show_in_modal', :id => current_user.cart
			respond_to do |format|
        	format.html { redirect_to(cart_path(current_user))}
        	format.xml  { head :ok }
        	format.js
        end
	end

	def edit
		@cart_item = CartItem.find(params[:id])
	end

	def destroy
		@cart_item = CartItem.find(params[:id])
		@cart_item.destroy
		respond_to do |format|
			format.js { render show_in_modal_cart_path(current_user) }
        	format.html { redirect_to(cart_path(current_user), :notice => 'Item successfully deleted.')}
        	format.xml  { head :ok }
    	end
    session[:cart_size] = current_user.cart.cart_items.size

	end

	def update
		@cart_item = CartItem.find(params[:cart_item_id])
		respond_to do |format|
			if params[:cart_item][:quantity] == "0" || @cart_item.update_attributes(params[:cart_item])
				if params[:cart_item][:quantity] == "0"
					@cart_item.destroy
					@notice = 'Item successfully deleted'
				end
				if @notice.nil?
					@notice = 'Item successfully updated.'
				end
				format.js { render show_in_modal_cart_path(params[:id]) }
				format.html { redirect_to(cart_path(params[:id], :item => @cart_item.id, :disable => true), :notice => @notice) }
				format.xml  { head :ok }       
			else
				errors = @cart_item.item.name + " could not be updated. "
				if(@cart_item.errors.any?)
					errors += @cart_item.errors.full_messages.to_sentence + "."
				end
				format.js { render :js => "var error = '#{errors}'; alert(error);" }
				format.xml  { render :xml => @cart_item.errors, :status => :unprocessable_entity }
			end
		end
		session[:cart_size] = current_user.cart.cart_items.size
	end
end
