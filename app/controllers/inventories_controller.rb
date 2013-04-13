class InventoriesController < ApplicationController
helper_method :sort_column, :sort_direction
skip_before_filter :require_login, :only => [:show, :index, :show_in_index, :show_all]

  #PUT
  def show
    #need to add permissions checking
      @title = "View Inventory"
      @remote = false
      @put_action = 'show'
      @producer = User.find(params[:id])

      if !params[:inventory].nil?
        @category = params[:inventory][:category]
        @category_id = Category.find_by_name(@category).id
      else
        @category = nil
        @category_id = nil
      end

      @item = Kaminari.paginate_array(sorted_items.to_a).page(params[:page]).per(10)
      respond_to do |format|
        format.html
        format.xml  { render :xml => @item }
    end
  end

  def show_in_index
      @title = "Our Producers"
      @remote = true
      @producer = User.find(params[:id])
      @put_action = 'show_in_index'
      if !params[:inventory].nil?
        @category = params[:inventory][:category]
        @category_id = Category.find_by_name(@category).id
      else
        @category = nil
        @category_id = nil
      end
      
      @item = Kaminari.paginate_array(sorted_items.to_a).page(params[:page]).per(10)
      respond_to do |format|
           format.js { render :locals => { :item => @item} }
      end
  end

   def index
    @title = "Our Producers"
    @producers = Inventory.all
    @categories = Category.all
    @items = Kaminari.paginate_array(Item.all.to_a).page(params[:page]).per(10)
  end

  def show_by_category
    render :action => 'show_in_index', :category => params[:category]
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

private

  def filtered_items
    if @category_id.nil?
      return Item.where("inventory_id = ?", params[:id])
    else
      return Item.where("inventory_id = ? AND category_id = ?", params[:id], @category_id)
    end
  end

  def sorted_items
    if sort_column == "category_id"
      @item = filtered_items
      if sort_direction == "asc"
        return @item.sort_by{|i| i.category.name }
      else
        return @item.sort_by{|i| i.category.name }.reverse
      end
    end
    return filtered_items.order(sort_column + " " + sort_direction)
  end

  def sort_column
    Item.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
