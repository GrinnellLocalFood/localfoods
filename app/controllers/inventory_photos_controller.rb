class InventoryPhotosController < ApplicationController
	def destroy
		respond_to do |format|
        @photo = InventoryPhoto.find(params[:id])
		@photo.destroy
		@photo = InventoryPhoto.new
        format.html { redirect_to(edit_user_path(current_user, :notice => @photo.photo.destroy.to_s)) }
        format.xml  { head :ok }
    	end
	end
end