class ItemsController < ApplicationController
  before_filter :check_permissions
  
  def check_permissions
    @user = current_user
    redirect_to @user unless signed_in? && (@user.coordinator || 
      @user.admin || @user.producer)
  end


  def index
    #need to add permissions checking
    @title = "My Products"
    if signed_in?
      @item = current_user.farm.item
    end
  end

  def new
    @title = "New Item"
    @item = Item.new

    respond_to do |format|
      format.html #new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def create
    @item = Item.new(params[:item])

    if current_user.producer?
      @farm = current_user.farm
    elsif current_user.coordinator || current_user.admin
      @farm = current_user.farm
    else
      redirect_to current_user
    end

    respond_to do |format|
      if @farm.item << @item
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
     if @item.farm_id == current_user.id
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
  end

end
