class UsersController < ApplicationController

  skip_before_filter :require_login, :only => [:new, :create]
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

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

    #   #admin automatically gets access. if not admin, checks to see if you're the right user
    #   unless signed_in? || current_user.admin || current_user=@user
    #     redirect_to :controller => "pages", :action => "home"
    # end


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

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        if current_user != nil && (current_user.admin || current_user.coordinator)
          sign_in current_user
          format.html { redirect_to(users_path, :notice => 'User was successfully updated.') }
          format.xml  { head :ok }
        else
          sign_in @user
          format.html { redirect_to(current_user, :notice => 'User was successfully updated.') }
          format.xml  { head :ok }
        end
        
      else
        sign_in @user
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
          format.html { redirect_to(@user, :alert => 'User was successfully updated.') }
         format.xml  { head :ok }
       else
          sign_in @user
          format.html { render :action => "editpassword" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end

# FIX HOW ALERTS ARE FLASHED HERE

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
end
