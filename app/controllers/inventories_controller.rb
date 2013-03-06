class InventoriesController < ApplicationController

skip_before_filter :require_login, :only => [:show, :index, :show_in_index, :show_all]

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

  def show_all
  @items = Item.all
  respond_to do |format|
      format.js { render :locals => { :items => Item.all } }
  end
 end

  def index
    @title = "Our Producers"
    @producers = Inventory.all
    @categories = Category.all
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def update
    @inventory = Inventory.find(params[:id])

    respond_to do |format|
      if @inventory.update_attributes(params[:inventory])
          format.html { redirect_to(inventory_path(params[:id]), :notice => 'Items were successfully updated.') }
          format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @inventory.errors, :status => :unprocessable_entity }
      end
    end
  end


  def add
    @inventory = Inventory.find(params[:id])
    20.times {@inventory.item.build}
  end

end
