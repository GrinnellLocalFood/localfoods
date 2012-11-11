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
      response.should redirect_to(login_path)
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

  describe "for non-signed-in users" do
    it "should deny access" do
      Factory(:user,:id => 37)    
      get :show, :id => "37"
      response.should redirect_to(login_path)
    end
  end

  describe "for signed_in users" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    it "should succeed" do 
      @another_user = Factory(:user,:id => 38,:email => "example38@example.com")    
      get :show, :id => "38"
      response.should be_success
    end
  end
end

  describe "GET new" do
    it "assigns a new user as @user" do
      @user = Factory(:user)
      User.should_receive(:new).and_return(@user)
      get :new
      assigns(:user).should eq(@user)
    end
  end

  describe "GET edit" do

    describe "for non-signed-in users" do
    
    it "should deny access" do
      @another_user = Factory(:user,:id => 38, :email => "example38@example.com")
      get :edit, :id => "38"
      response.should redirect_to(login_path)
    end
  end

   describe "for signed_in users" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    it "should succeed given correct index" do 
      get :edit, :id => @user.id
      response.should be_success
    end

    it "should succeed given any index" do 
      get :edit, :id => @user.id + 20
      response.should be_success
      assigns(:user).should eq(@user)
    end
  end

 describe "for admins" do
    before(:each) do
      @user = test_sign_in(Factory(:user, :admin => true))
    end

    it "should succeed given correct index" do 
      get :edit, :id => @user.id
      response.should be_success
    end

    it "should succeed given any index" do   
      @another_user = Factory(:user, :id => @user.id + 20, :email => "example20@example.com")
      get :edit, :id => @user.id + 20
      response.should be_success
      assigns(:user).should eq(@another_user)
    end
  end
end



  describe "POST create" do

    describe "success for non-admins" do

      before(:each) do
      @attr = { :id => -1, 
        :first_name => "Example", 
        :last_name => "User", 
        :email => "user@example.com", 
        :password => "password",
        :password_confirmation => "password"}
     end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end

    describe "success for admins" do
    
    before(:each) do
      @admin = test_sign_in(Factory(:user, :admin => true))
      @attr = { :id => -1, 
        :first_name => "Example", 
        :last_name => "User", 
        :email => "user@example.com", 
        :password => "password",
        :password_confirmation => "password"}
     end
      
      it "should not redirect to the created user's show page" do
        post :create, :user => @attr
        response.should redirect_to(@admin)
      end

      it "@admin should stay signed in" do
        post :create, :user => @attr
        controller.should be_user_signed_in(@admin)
      end
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :id => -1, 
        :first_name => "Example", 
        :last_name => "User", 
        :email => "user@example.com", 
        :password => "password",
        :password_confirmation => "" }
      end
  
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
    end

  end

  describe "PUT update" do

    describe "for signed-in users" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      
      before(:each) do
        @attr = {:first_name => "", :email => ""}
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
    end

    describe "success" do
      
      before(:each) do
        @attr = { :first_name => "New Name", :email => "user@example.org"}
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.first_name.should == @attr[:first_name]
        @user.email.should == @attr[:email]
      end
    end
  end

  describe "for admins" do
    before(:each) do
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
      @user = Factory(:user, :email => "user_email@example.com")
    end
   
    describe "failure" do      
      before(:each) do
        @attr = {:first_name => "", :email => ""}
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
    end

    describe "success" do
      
      before(:each) do
        @attr = { :first_name => "New Name", :email => "user@example.org"}
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.first_name.should == @attr[:first_name]
        @user.email.should == @attr[:email]
      end
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
