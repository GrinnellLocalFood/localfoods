class InventoriesController < ApplicationController
  before_filter :check_permissions
  
  def check_permissions
    @user = current_user
    redirect_to @user unless signed_in? && (@user.coordinator || 
      @user.admin || @user.farmer)
  end


  def index
    #need to add permissions checking
    @title = "My Products"
    if signed_in?
      @inventory = current_user.farm.inventory
    end
  end

  def new
    @title = "New Item"
    @inventory = Inventory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @inventory }
    end
  end

  def create
    @inventory = Inventory.new(params[:inventory])

    if current_user.farmer?
      @farm = current_user.farm
    elsif current_user.coordinator || current_user.admin
      @farm = current_user.farm
    else
      redirect_to current_user
    end

    respond_to do |format|
      if @farm.inventory << @inventory
        sign_in @user
        flash[:notice] = @inventory.name + " saved!"
        format.html { redirect_to(inventories_path, :notice => 'User was successfully created.',
          :class=>"alert alert-success") }

         # format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        sign_in @user
        flash[:notice] = @inventory.name + " could not be saved."
        format.html { redirect_to(inventories_path, :notice => 'User was successfully created.',
          :class=>"alert alert-success") }

         # format.xml  { render :xml => @user, :status => :created, :location => @user }
      end
    end
  end


  def destroy
    respond_to do |format|
      format.html
    end
  end

  def edit
    @title = "Edit"
  end

  def show
  end

end
