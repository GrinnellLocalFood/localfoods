class InventoriesController < ApplicationController

skip_before_filter :require_login, :only => [:show, :index, :show_in_index]



 def edit
    @title = "Edit Producer Profile"
    if(current_user.admin || current_user.coordinator)
    	@inventory = Inventory.find(params[:id])
      3.times{@inventory.inventory_photos.build}
    elsif(current_user.producer)
       	@inventory = current_user.inventory
        3.times{@inventory.inventory_photos.build}
    else
    	redirect_to current_user
    end
  end


  def update
  	@inventory = current_user.inventory
    3.times{@inventory.inventory_photos.build}
    respond_to do |format|
      if @inventory.update_attributes(params[:inventory])
          format.html { redirect_to(current_user, :notice => 'Producer Profile was successfully updated.') }
          format.xml  { head :ok }       
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @inventory.errors, :status => :unprocessable_entity }
      end
    end
   end

  #PUT
  def show
    #need to add permissions checking
      @title = "View Inventory"
      @producer = User.find(params[:id])
      @item = Item.where("inventory_id = ?", params[:id])
      respond_to do |format|
        format.html
        format.xml  { render :xml => @item }
    end
  end

  def show_in_index
      @title = "Our Producers"
      @producer = User.find(params[:id])
      @item = Item.where("inventory_id = ?", params[:id])
      respond_to do |format|
        format.js { render :locals => { :item => @item } }
      end
  end

  def index
    @title = "Our Producers"
    @producers = Inventory.all
  end

end
