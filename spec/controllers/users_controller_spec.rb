require 'spec_helper'

describe UsersController do


  
  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    describe "for non-signed-in users" do
    
    it "should deny access" do
      get :index
      response.should redirect_to(root_path)
    end
  end

    describe "for signed_in users" do
      before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    it "should redirect to user page" do 
      get :index
      response.should redirect_to(@user)
    end
  end

  describe "for admin users" do
    before(:each) do
      @user = test_sign_in(Factory(:user,:admin => true))
    end

    it "should be successful" do 
      get :index
      response.should be_success
    end
  end
end

  describe "GET show" do
    it "gets page for current user" do
      User.stub(:find).with("37") { mock_user }     
      get :show, :id => "37"
      assigns(:user).should eq(mock_user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      User.stub(:new) { mock_user }
      get :new
      assigns(:user).should eq(mock_user)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      User.stub(:find).with("37") { mock_user }
      get :edit, :id => "37"
      assigns(:user).should be(mock_user)
    end
  end

  describe "POST create" do

    before(:each) do
      @attr = { :user_id => -1, 
        :first_name => "Example", 
        :last_name => "User", 
        :email => "user@example.com", 
        :password => "password",
        :password_confirmation => "password"}
    end

    describe "with valid params" do
      it "assigns a newly created user as @user" do
        User.stub(:new).with({'these' => 'params'}) { mock_user(:save => true) }
        post :create, :user => {'these' => 'params'}
        assigns(:user).should be(mock_user)
      end

      it "redirects to the created user" do
        User.stub(:new) { mock_user(:save => true) }
        post :create, :user => {}
        response.should redirect_to(user_url(mock_user))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        User.stub(:new).with({'these' => 'params'}) { mock_user(:save => false) }
        post :create, :user => {'these' => 'params'}
        assigns(:user).should be(mock_user)
      end

      it "re-renders the 'new' template" do
        User.stub(:new) { mock_user(:save => false) }
        post :create, :user => {}
        response.should render_template("new")
      end
    end

    describe "success" do
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested user" do
        User.should_receive(:find).with("37") { mock_user }
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :user => {'these' => 'params'}
      end

      it "assigns the requested user as @user" do
        User.stub(:find) { mock_user(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:user).should be(mock_user)
      end

      it "redirects to the user" do
        User.stub(:find) { mock_user(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(user_url(mock_user))
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        User.stub(:find) { mock_user(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:user).should be(mock_user)
      end

      it "re-renders the 'edit' template" do
        User.stub(:find) { mock_user(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      User.should_receive(:find).with("37") { mock_user }
      mock_user.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the users list" do
      User.stub(:find) { mock_user }
      delete :destroy, :id => "1"
      response.should redirect_to(users_url)
    end
  end

  describe "GET editpassword" do
    it "assigns the requested user as @user" do
      User.stub(:find).with("37") { mock_user }
      get :editpassword, :id => "37"
      assigns(:user).should be(mock_user)
    end
  end

 describe "PUT updatepassword" do

    describe "with valid params" do
      it "updates the requested user" do
        User.should_receive(:find).with("37") { mock_user }
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :updatepassword, :id => "37", :user => {'these' => 'params'}
      end

      it "assigns the requested user as @user" do
        User.stub(:find) { mock_user(:update_attributes => true) }
        put :updatepassword, :id => "1"
        assigns(:user).should be(mock_user)
      end

      it "redirects to the user" do
        User.stub(:find) { mock_user(:update_attributes => true) }
        put :updatepassword, :id => "1"
        response.should redirect_to(user_url(mock_user))
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        User.stub(:find) { mock_user(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:user).should be(mock_user)
      end

      it "re-renders the 'editpassword' template" do
        User.stub(:find) { mock_user(:update_attributes => false) }
        put :updatepassword, :id => "1"
        response.should render_template("editpassword")
      end
    end

  # describe "GET adduser" do

  #   describe "called by admin" do
  #     it "should have a page at /users/:id/adduser"
      

  end
end
