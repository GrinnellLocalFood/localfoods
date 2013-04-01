class InventoriesController < ApplicationController
  helper_method :sort_column, :sort_direction

skip_before_filter :require_login, :only => [:show, :index, :show_in_index, :show_all]

  #PUT
  def show
    #need to add permissions checking
      @title = "View Inventory"
      @remote = false
      @producer = User.find(params[:id])
      @item = Item.where("inventory_id = ?", params[:id]).order(sort_column + " " + sort_direction)
      @sort_c = nil
      @sort_d = nil
      respond_to do |format|
        format.html
        format.xml  { render :xml => @item }
    end
  end

  def show_in_index
      @title = "Our Producers"
      @remote = true
      @producer = User.find(params[:id])
      @item = Item.where("inventory_id = ?", params[:id]).order(sort_column + " " + sort_direction)
      respond_to do |format|
           format.js { render :locals => { :item => @item, :@sort_c => sort_column, :@sort_d => sort_direction } }
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
        if(params[:add])
          format.html { render :action => "add", :reload => true }
        else
          format.html { render :action => "edit" }
        end
        format.xml  { render :xml => @inventory.errors, :status => :unprocessable_entity }
      end
    end
  end


  def add
    @edit = false
    @inventory = Inventory.find(params[:id])
    if (!params[:reload])
      20.times {@inventory.item.build}
    end
  end

  
  def sort_column
    Item.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
