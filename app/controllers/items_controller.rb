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

    # if params[:item][:inventory_id].nil?
    #   user = current_user
    # else
    #   user = User.find(params[:item][:inventory_id])

    inv_id = params[:item][:inventory_id]
    
    if inv_id.blank?
      #if they are admin and it is blank, they did not pick a producer
      @inventory = current_user.inventory
    else
      @inventory = Inventory.find(inv_id)
    end

    # if current_user.producer?
    #   @inventory = current_user.inventory
    # elsif current_user.coordinator || current_user.admin
    #   @inventory = current_user.inventory
    # else
    #   redirect_to current_user
    # end

    respond_to do |format|
      if @inventory.item << @item
        sign_in @user
        flash[:notice] = @item.name + " saved!"
        format.html { redirect_to(items_path, :notice => 'Item was added successfully.',
          :class=>"alert alert-success") }

         # format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        sign_in @user
        flash[:notice] = @item.name + " could not be saved."
        format.html { redirect_to(items_path, :notice => 'Item was added successfully.',
          :class=>"alert alert-success") }

         # format.xml  { render :xml => @user, :status => :created, :location => @user }
      end
    end
  end


  def destroy
    
      @item = Item.find(params[:id])
     if @item.inventory_id == current_user.id
        respond_to do |format|
        @item.destroy
        format.html { redirect_to(items_path) }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        flash[:error] = "Could not delete item."
        format.html { redirect_to(items_path) }
        format.xml  { head :ok }
    end
    end
  end
  
  def edit
    @title = "Edit"
  end

  def show
     @item = Item.find(params[:id])
  end

end
