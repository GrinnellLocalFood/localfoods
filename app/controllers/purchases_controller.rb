class PurchasesController < ApplicationController
	helper_method :sort_column, :sort_direction
	prawnto :prawn => { :top_margin => 75 }
	
	def new
		# The following validates whether itams still exist
		@changed_items = current_user.cart.invalid_items
		if(current_user.cart.is_empty?)
			render "error"			
		else
			@purchase = Purchase.new
		end	
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
		if params[:order_view].nil?
			@purchases = Purchase.all(:include => [:user, :item => :inventory])
			@purchases = sorted_purchases

			respond_to do |format|
				format.html do
					render "all_orders"
				end

				format.pdf do
					pdf = OrderPdf.new(@purchases, @title, view_context)
					send_data pdf.render, filename: "all_orders.pdf",
					type: "application/pdf",
					disposition: "inline"
				end
			end
			
		elsif params[:order_view] == "Buyer"
			@title = "All Orders > By Buyer"
			@purchases_by_user = Hash.new
			Purchase.uniq.pluck(:user_id).map {|id| @purchases_by_user[User.find(id)] = 
				Purchase.where("user_id = ?", id).order("paid asc")}
				@purchases_by_user.keys.sort
				render "buyer"
			elsif params[:order_view] == "Producer"
				@title = "All Orders > By Producer"
				@purchases_by_producer = Hash.new
				Purchase.uniq.pluck(:inventory_id).map {|id| @purchases_by_producer[Inventory.find(id)] = 
					Purchase.where("inventory_id = ?", id).order("paid asc")}
					@purchases_by_producer.keys.sort
					render "producer"
				end		

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
