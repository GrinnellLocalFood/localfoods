class ApplicationStatesController < ApplicationController
	def editorderstate
   @title = "Open or Close Orders"
   @application_state = ApplicationState.get_state
    if(!current_user.admin)
      redirect_to current_user
    end
  end

  def edit
    @application_state = ApplicationState.get_state 
  end

  def update
    @application_state = ApplicationState.get_state

    respond_to do |format|
      if @application_state.update_attributes(params[:application_state])
        if(params[:edit_form] == "true")
          format.html { redirect_to('/', :notice => 'Text successfully updated!') }
        else

          if (params[:application_state][:email_users] == "true")
            User.all.each do |user|
              UserMailer.order_status_change(user, params[:application_state][:email_content], @application_state.orders_open).deliver
            end
          end

          if(params[:application_state][:clear_carts] == "true" && params[:application_state][:orders_open] == "false")
            Cart.clear_all
          end

          if(@application_state.orders_open)
            format.html { redirect_to(current_user, :notice => 'Order status changed to open') }
          else
            format.html { redirect_to(current_user, :notice => 'Order status changed to closed' ) }
          end

        end
      else # else for update
        format.html { render :action => (params[:edit_form] == "true") ? "edit" : "editorderstate" }
        format.xml  { render :xml => @application_state.errors, :status => :unprocessable_entity }
      end # if update end
    end #do end
  end #update end

  def sendemail
    group = params[:application_state][:group]

    # if group was invalid, fail and redirect them back to the email page
    if group == ''
      redirect_to(email_path, :options => {:alert => 'Invalid Group'})
      return
    elsif group == 'all'
      users = User.all
    elsif group == 'producers'
      users = User.where(:producer => true)
    end

    users.each do |user|
      UserMailer.email_users(user, "Subject", params[:application_state][:email_content]).deliver
    end
    redirect_to(current_user, :notice => 'Email successfully sent')

  end

  def emailusers
     @application_state = ApplicationState.get_state
  end



end #class end

