class ItemsController < ApplicationController
  before_filter :check_permissions, :except => [:show, :index, :search]
  skip_before_filter :require_login, :only => [:show, :index, :search]
  
  def check_permissions
    @user = current_user
    redirect_to @user unless signed_in? && (@user.coordinator || 
      @user.admin || @user.producer)
  end

  def search
    @search = Item.search do
      fulltext params[:search]
    end
    @items = @search.results
  end

  def index
  @title = "All Products"
  @categories = Category.all
  end

  #PUT
  def public_index
    #need to add permissions checking
  
      @title = "View Inventory"
    
      @item = Item.where("inventory_id = ?", params[:item][:inventory_id])
      respond_to do |format|
        format.html
        format.xml  { render :xml => @item }
    end
  end

  def producer_index
    @title = "View Inventory"

    if current_user.producer
      @item = current_user.inventory.item
    else
      redirect_to(current_user)
    end
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
     if (current_user.admin || current_user.coordinator || current_user.id == @item.inventory_id)
        respond_to do |format|
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

  private

  def create_helper(action)
    @item = Item.new(params[:item])
    @inventory = Inventory.find(params[:inventory_id])

    respond_to do |format|
      if (current_user.admin || current_user.coordinator || current_user.id == @item.inventory_id)
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


end
