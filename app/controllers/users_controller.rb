class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
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
    @user = User.find(params[:id])
  end

  # GET /users/1/editpassword
  def editpassword
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        sign_in @user
        # format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.html { redirect_to @user }
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
        if current_user.admin
          sign_in current_user
        else
          sign_in @user
        end
        format.html { redirect_to(current_user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        sign_in @user
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1/updatepassword
  # PUT /users/1.xml
  def updatepassword
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        sign_in @user
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        sign_in @user
        format.html { render :action => "editpassword" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end   

  # # GET /users/1/adduser
  # def adduser
  #   @user = User.find(params[:id])

  #   respond_to do |format|
  #     if @user.admin?
  #       sign_in @user
  #       format.html { redirect_to()}

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
