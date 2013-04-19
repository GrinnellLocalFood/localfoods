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
    if (params[:application_state][:email_users] == "true")
      User.all.each do |user|
        UserMailer.order_status_change(user, params[:application_state][:email_content], @application_state.orders_open).deliver
      end
    end
    if(params[:application_state][:clear_carts] == "true" && params[:application_state][:open_orders] == "false")
      Cart.clear_all
    end
    if(@application_state.orders_open)
      format.html { redirect_to(current_user, :notice => 'Order status changed to open') }
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
