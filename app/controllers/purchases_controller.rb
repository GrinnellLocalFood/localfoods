class PurchasesController < ApplicationController
	helper_method :sort_column, :sort_direction
	
	def new
		@purchase = Purchase.new
	end

	def create
		Purchase.create_purchases(current_user.cart, false, nil)
		redirect_to :action => 'index'
	end		

	def index
		@title = "Order History"
		@orders = Purchase.where("user_id = ?", current_user.id).order("created_at desc").uniq.pluck(:order_set)

		if @orders.include?("unpaid")
			@orders.delete("unpaid")
			@orders << "unpaid"
		end
	end

	def all_orders
		@title = "All Orders"
		@purchases = Purchase.all
		@purchases = sorted_purchases
	end

	def process_order
		redirect_to :action => 'index'
	end

	def sorted_purchases

		if sort_column == "buyer"
			if sort_direction == "asc"
				return @purchases.sort_by{|i| i.user.name }
			else
				return @purchases.sort_by{|i| i.user.name }.reverse
			end
		end

		if sort_column == "producer"
			if sort_direction == "asc"
				return @purchases.sort_by{|i| i.item.inventory.display_name }
			else
				return @purchases.sort_by{|i| i.item.inventory.display_name }.reverse
			end
		end

		if sort_column == "product"
			if sort_direction == "asc"
				return @purchases.sort_by{|i| i.item.name }
			else
				return @purchases.sort_by{|i| i.item.name }.reverse
			end
		end

		if sort_column == "paid_for"
			if sort_direction == "asc"
				return @purchases.sort_by{|i| i.paid.to_s }
			else
				return @purchases.sort_by{|i| i.paid.to_s }.reverse
			end
		end
		return @purchases
	end


    
  def sort_column
    ["buyer", "producer", "product", "paid_for"].include?(params[:sort]) ? params[:sort] : "product"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
