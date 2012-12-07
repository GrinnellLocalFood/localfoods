class ItemsController < ApplicationController
  before_filter :check_permissions, :except => :public_index
  skip_before_filter :require_login, :only => :public_index
  
  def check_permissions
    @user = current_user
    redirect_to @user unless signed_in? && (@user.coordinator || 
      @user.admin || @user.producer)
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

    respond_to do |format|
      format.html #new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def admin_coord_new
    @title = "Add Item for a Producer"
    @item = Item.new
    @inventories = Inventory.where("hidden = ?", false)

    respond_to do |format|
      format.html #new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def create
    @item = Item.new(params[:item])
    @inventory = Inventory.find(params[:inventory_id])

    respond_to do |format|
      if @inventory.item << @item
        sign_in @user
        flash[:notice] = @item.name + " saved!"
        format.html { redirect_to(public_index_inventory_path(@inventory), :notice => 'Item was added successfully.',
          :class=>"alert alert-success") }

         # format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        sign_in @user
        flash[:notice] = @item.name + " could not be saved."
        format.html { redirect_to(public_index_inventory_path(@inventory), :notice => 'Item was added successfully.',
          :class=>"alert alert-success") }

         # format.xml  { render :xml => @user, :status => :created, :location => @user }
      end
    end
  end

  def update
    @item = Item.find(params[:id])
    @inventory = Inventory.find(params[:inventory_id])

    respond_to do |format|
      sign_in @user
      if (current_user.admin || current_user.coordinator || current_user.id == @item.inventory_id)
        if @item.update_attributes(params[:item])
          debugger
          flash[:notice] = @item.name + " updated!"
          format.html { redirect_to(public_index_inventory_path(@inventory), :notice => 'Item was added successfully.',
          :class=>"alert alert-success") }
        end
      else
        flash[:error] = "You do not have permission to perform this action."
        format.html { redirect_to(public_index_inventory_path(@inventory)) }
        format.xml  { head :ok }
      end
    end
  end


  def destroy   
    @item = Item.find(params[:id])
     if (current_user.admin || current_user.coordinator || current_user.id == @item.inventory_id)
        respond_to do |format|
        @item.destroy
        format.html { redirect_to(public_index_inventory_path(params[:inventory_id])) }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        flash[:error] = "Could not delete item."
        format.html { redirect_to(public_index_inventory_path(params[:inventory_id])) }
        format.xml  { head :ok }
      end
    end
  end
  
  def edit
    @title = "Edit Item"
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @item }
    end
  end

  def show
    @item = Item.find(params[:id])
    @title = @item.name

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @item }
    end
  end

end
