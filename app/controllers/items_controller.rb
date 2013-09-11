class ItemsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :check_permissions, :except => [:show, :show_in_modal, :index, :search]
  skip_before_filter :require_login, :only => [:show, :show_in_modal, :index, :search]
  
  layout 'blank', :only => :show_in_modal 

  def check_permissions
    @user = current_user
    redirect_to @user unless signed_in? && (@user.coordinator || 
      @user.admin || @user.producer)
  end

  def search
    @search = Item.search do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 10
      order_by sort_column.to_sym, sort_direction.to_sym
    end
    @items = @search.results
  end

  def producer_new
    @title = "New Item"
    @item = Item.new
    @url = inventory_items_path
  end

  def admin_coord_new
    @title = "Add Item for a Producer"
    @item = Item.new
    @inventories = Inventory.where("hidden = ?", false)
  end

  def create
    create_helper("producer_new")
  end

  def admin_create
    create_helper("admin_coord_new")
  end

  def update
  @item = Item.find(params[:id])
  respond_to do |format|
    if (current_user.admin || current_user.coordinator || current_user.id == @item.inventory_id)
      if @item.update_attributes(params[:item])
        format.html { redirect_to(inventory_path(@item.inventory_id), :alert => 'Item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    else
      flash[:error] = "You do not have permission to perform this action."
      format.html { redirect_to(inventory_path(@inventory)) }
      format.xml { head :ok }
    end
  end
end

  def destroy   
    @item = Item.find(params[:id])
	# Over here, we can just use item.inventory_id to determine who's inventory it's in, since 
	# it already exists in the database.
     if (current_user.admin || current_user.coordinator || current_user.id == @item.inventory_id)
        respond_to do |format|
        @cart_items = CartItem.where('item_id = ?', @item.id)
        unless @cart_items.nil?
          @cart_items.each do |cart_item|
            cart_item.destroy
          end
        end
        @item.destroy
        format.html { redirect_to(inventory_path(params[:inventory_id])) }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        flash[:error] = "Could not delete item."
        format.html { redirect_to(inventory_path(params[:inventory_id])) }
        format.xml  { head :ok }
      end
    end
  end
  
  def edit
   @title = "Edit"
   @item = Item.find(params[:id])
   @url = inventory_item_path(:inventory_id => @item.inventory_id, :id => @item.id)
 end
 
  def show
    @item = Item.find(params[:id])
    @title = @item.name
  end

  def show_in_modal
    @item = Item.find(params[:id])
    @title = @item.name
  end

  private

  def create_helper(action)
    @item = Item.new(params[:item])
    @inventory = Inventory.find(params[:inventory_id])
	logger.debug "Inventory ID #{params[:inventory_id]} #{current_user.id}"
    respond_to do |format|
	# Since the @item is created from the params[:item] hash, it has not been placed in the database yet,
	# and so will not have an inventory_id yet. So instead we use params[:inventory_id] to figure out
	# which inventory this item will be added to. We need to do to_i since the param comes in as a string.
      if (current_user.admin || current_user.coordinator || current_user.id == params[:inventory_id].to_i)
        if @inventory.item << @item
          format.html { redirect_to(inventory_path(@inventory), :alert => 'Item was added successfully.',
            :class=>"alert alert-success") }

           # format.xml  { render :xml => @user, :status => :created, :location => @user }
        else
          format.html { render :action => action, :notice => @item.name + " could not be saved.",
            :class=>"alert alert-success" }
          format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
        end
       else
        flash[:error] = "You do not have permission to perform this action."
        format.html { redirect_to(inventory_path(@inventory)) }
        format.xml { head :ok }
      end
    end
  end

  private

  def sort_column
    ["name","inventory","category","price"].include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
