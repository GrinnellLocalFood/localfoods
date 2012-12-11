class CategoriesController < ApplicationController

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
	      format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
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

def show_by_category
    @category = Category.find(params[:id])
    @items = @category.items
    render :update do |page|
      page.replace_html 'category_info', :partial => 'show'
    end
 end

 def show_all
 	@items = Item.all
 	render :update do |page|
      page.replace_html 'category_info', :partial => 'show'
    end
 end

  def destroy   
    @category = Category.find(params[:id])
     if (current_user.admin)
        respond_to do |format|
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


end
