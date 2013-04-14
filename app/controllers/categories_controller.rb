class CategoriesController < ApplicationController
helper_method :sort_column, :sort_direction
skip_before_filter :require_login, :only => [:show_by_category, :show_all]

def new
end

def create
	@category = Category.new(params[:category])
	@categories = Category.all
		
	respond_to do |format|
	  if (current_user.admin)
	    if @category.save
	      format.html { redirect_to(categories_path, :notice => "Category " + @category.name + " added!",
	        :class=>"alert alert-success") }
	    else
	      format.html { render :action => 'index', :notice => "Category " + @category.name + "could not be added. Please try again.",
	        :class=>"alert alert-success" }
	      format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
	    end
	  else
	    flash[:error] = "You do not have permission to perform this action."
	    format.html { redirect_to(current_user) }
	    format.xml { head :ok }
	  end
	end
end

def index
	@categories = Category.all
	@category = Category.new
end

def show_all
    if params[:category].nil? || params[:category].blank?
      @category = nil
      @category_obj = nil
    else
      @category = params[:category]
      @category_obj = Category.find_by_name(@category)
    end
    @items = Kaminari.paginate_array(sorted_items(@category_obj)).page(params[:page]).per(10)
   	respond_to do |format|
      format.js { render :locals => { :items => @items } }
  end
end

  def destroy   
    @category = Category.find(params[:id])

     if (current_user.admin && @category.name != "Other")
        respond_to do |format|
        
        # Change category to "Other" when a category is deleted
        @category.items.each do |item|
          item.category_id = Category.find_by_name("Other").id
          item.save
        end

        @category.destroy
        format.html { redirect_to(categories_path) }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        flash[:error] = "Could not delete item."
       format.html { redirect_to(categories_path) }
       format.xml  { head :ok }
      end
    end
  end

  private 

  def filtered_items(category)
    if category.nil?
      Item
    else
      Item.where("category_id = ?", category.id)
    end
  end

  def sorted_items(category)
    @item = filtered_items(category)

    if params[:sort] == "available"
      if sort_direction == "asc"
        return @item.sort_by{|i| i.is_available? }
      else
        return @item.sort_by{|i| i.is_available? }.reverse
      end
    end

    if params[:sort] == "producer"
      if sort_direction == "asc"
        return @item.sort_by{|i| i.inventory.display_name }
      else
        return @item.sort_by{|i| i.inventory.display_name }.reverse
      end
    end

    if params[:sort] == "category"
      if sort_direction == "asc"
        return @item.sort_by{|i| i.category.name }
      else
        return @item.sort_by{|i| i.category.name }.reverse
      end
    end

    return filtered_items(category).order(sort_column + " " + sort_direction)
  end

  def sort_column
    Item.column_names.include?(params[:sort]) || ["producer", "category", "available"].include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
