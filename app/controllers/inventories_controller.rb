class InventoriesController < ApplicationController
  before_filter :check_permissions
  
  def check_permissions
    @user = current_user
    redirect_to @user unless signed_in? && (@user.coordinator || 
      @user.admin || @user.farmer)
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
      #item was saved correctly
        sign_in @user
        flash[:notice] = @inventory.name + " saved!"
        redirect_to inventories_path
      else
        sign_in @user
        flash[:notice] = @inventory.name + " could not be saved."
        redirect_to inventories_path
      end
    end
  end

  def destroy
  end

  def edit
  end

  def show
  end

end
