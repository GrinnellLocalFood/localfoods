class InventoriesController < ApplicationController

 def edit
    @title = "Edit Producer Profile"
    if(current_user.admin || current_user.coordinator)
    	@inventory = Inventory.find(params[:id])
    elsif(current_user.producer)
       	@inventory = current_user.inventory
    else
    	redirect_to current_user
    end
  end


  def update
  	@inventory = current_user.inventory
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


end
