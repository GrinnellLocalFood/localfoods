class ApplicationStatesController < ApplicationController
	def editorderstate
    	@title = "Open or Close Orders"
    	@application_state = ApplicationState.first
    	if(!current_user.admin)
    		redirect_to current_user
    	end
  	end

  	def update
  		@application_state = ApplicationState.first
    	respond_to do |format|
      	if @application_state.update_attributes(params[:application_state])
          if(@application_state.orders_open)
            format.html { redirect_to(current_user, :notice => 'Order status changed to open' ) }
          else
            format.html { redirect_to(current_user, :notice => 'Order status changed to closed' ) }
          end
          format.xml  { head :ok }       
      else
        format.html { render :action => "editorderstate" }
        format.xml  { render :xml => @application_state.errors, :status => :unprocessable_entity }
      end
    end
    end
end
