class InventoriesController < ApplicationController

skip_before_filter :require_login, :only => [:show, :index, :show_in_index]

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

end
