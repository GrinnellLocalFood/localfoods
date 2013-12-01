class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  skip_before_filter :require_login, :only => [:new, :create]
  # GET /users
  # GET /users.xml
  def index
    @users = User.all
    @users = sorted_users

    if current_user.admin || current_user.coordinator
        respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
    else
      redirect_to current_user
    end
  end 

  # GET /users/1
  # GET /users/1.xml
  def show
    @title = "Account"
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @title = "Register"
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @title = "Edit Account"

    if (current_user.admin || current_user.coordinator)
      @user = User.find(params[:id])
      
      if(!current_user.admin && @user.admin)
         redirect_to(current_user, :alert => "Permission Denied")
      end
    else
      @user = current_user
    end

    if(!@user.inventory.nil?)
        3.times {@user.inventory.inventory_photos.build}
    end

    session[:return_to] = nil
    if(params[:origin] == "header" || request.referrer.nil?)
      session[:return_to] = user_path(@user)
    else
      session[:return_to] ||= request.referer
    end
    
  end

  # GET /users/1/editpassword
  def editpassword
    @title = "Change Password"
    if(current_user == nil)
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save

        # Tell the UserMailer to send a welcome Email after save
        if(!current_user.nil?)
          UserMailer.welcome_email(request.host_with_port,@user, true).deliver
          @user = current_user
        else
          UserMailer.welcome_email(request.host_with_port,@user, false).deliver
        end        
        sign_in @user
        format.html { redirect_to(@user, :notice => 'User was successfully created.',
          :class=>"alert alert-success") }

        format.xml  { render :xml => @user, :status => :created, :location => @user }
        
      else
        #resets password and confirmation fields
        @user.password = ""
        @user.password_confirmation = ""
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def after_signin(format)
    session[:return_to] = user_path(@user) if(session[:return_to].nil?)

    format.html { redirect_to(session[:return_to], :notice => 'User was successfully updated.') }
    format.xml  { head :ok }
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        if current_user != nil && (current_user.admin || current_user.coordinator)
          sign_in current_user
          after_signin(format)
        else
          sign_in @user
          after_signin(format)
        end
        
      else
        sign_in @user

      if(!@user.inventory.nil?)
          2.times {@user.inventory.inventory_photos.build}
      end

        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  #PUT /users/1/updatepassword
  #PUT /users/1.xml
  def updatepassword
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.has_password?(params[:user][:old_password])
        if @user.update_attributes(params[:user])
          sign_in @user
          after_signin(format)
       else
          sign_in @user
          format.html { render :action => "editpassword" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end

      else
        flash.now[:alert] = "Old Password Incorrect."
        format.html { render :action => "editpassword" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end   

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if(current_user.admin)
      @user = User.find(params[:id])
      if !@user.inventory.nil?
        @user.inventory.destroy
      end
      @user.destroy

      respond_to do |format|
        format.html { redirect_to(users_path) }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to(current_user) }
        format.xml  { head :ok }
    end
   end
  end

private
  # Sorting #
  def sort_column
    ["name", "admin", "coordinator", "producer"].include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


  def sorted_users

    if sort_column == "name"
      if sort_direction == "asc"
        return @users.sort_by{|i| i.name }
      else
        return @users.sort_by{|i| i.name }.reverse
      end
    end

    # Need the boolean comparisons to return 0 or 1, because 
    # comparison operators (<, >) don't apply to bools. INstead we 
    # return an integer, which can be compared
    if sort_column == "admin"
      if sort_direction == "asc"
        return @users.sort_by{|i| i.admin ? 1 : 0 }
      else
        return @users.sort_by{|i| i.admin ? 1 : 0 }.reverse
      end
    end

    if sort_column == "producer"
      if sort_direction == "asc"
        # any non producers should go to the bottom of the list. We represent them
        # with "{" character, since its ascii code is greater than that of "Z", so
        # it will always get put at the end of the list
        return @users.sort_by{|i| i.producer ? i.inventory.display_name : "{" }
      else
        # same as above, except we want the non producers rigth at the TOP of the list
        # so we use "@" character, for the same ascii reasons
        return @users.sort_by{|i| i.producer ? i.inventory.display_name : "@"}.reverse
      end
    end

    if sort_column == "coordinator"
      if sort_direction == "asc"
        return @users.sort_by{|i| i.coordinator ? 1 : 0 }
      else
        return @users.sort_by{|i| i.coordinator ? 1 : 0 }.reverse
      end
    end

    return @users
  end

end
