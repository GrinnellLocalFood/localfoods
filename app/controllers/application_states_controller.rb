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
    users = Array.new
    application_state = ApplicationState.get_state
    greeting = "Members"

    # This update_attributes stores the greeting in the ApplicationState object
    if application_state.update_attributes(params[:application_state])
      # if group was invalid, fail and redirect them back to the email page
      if group == ''
        redirect_to(email_path, :options => {:alert => 'Invalid Group'})
        return
      elsif group == 'all'
        users = User.all
      elsif group == 'producers'
        users = User.where(:producer => true)
        greeting = "Producers"
      elsif group == 'purchasers'
        user_ids = Purchase.uniq.pluck(:user_id)
        user_ids.each do |user_id| 
          user = User.find(user_id)
          users << user
        end
      elsif group == 'members'
        users = User.where("producer = ? AND admin = ? AND coordinator = ? ", false, false, false)
      end

      if users.empty?
        redirect_to(current_user, :notice => 'No one to email.')
        return
      end
      
      user_emails = Array.new
      users.each do |user|
        user_emails << user.email
      end

      UserMailer.email_users(user_emails, params[:application_state][:email_subject], greeting, params[:application_state][:email_content], params[:application_state][:email_signoff]).deliver

      redirect_to(current_user, :notice => 'Email successfully sent')
    end
  end

  def emailusers
     @application_state = ApplicationState.get_state
  end



end #class end

