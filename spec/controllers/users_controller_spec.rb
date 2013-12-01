require 'spec_helper'

describe UsersController do
  render_views

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

  describe "for admins" do
    before(:each) do
      @user = test_sign_in(Factory(:user,:admin => true))
    end

    it "should be successful" do 
      get :index
      response.should be_success
    end
  end

   describe "for coordinators" do
    before(:each) do
      @user = test_sign_in(Factory(:user,:coordinator => true))
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

  describe "For admin" do
     before(:each) do
      @user = test_sign_in(Factory(:user, :admin => true))
    end
    it "should have New user and show user button" do    
      get :show, :id => "1"
        response.body.should have_text("All Users")
        response.body.should have_text("Add User") 
    end
  end

 describe "For coordinators" do
     before(:each) do
      @user = test_sign_in(Factory(:user, :coordinator => true))
    end
    it "should have New user and show user button" do    
      get :show, :id => "1"
      response.body.should have_text("All Users")
      response.body.should have_text("Add User")
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

    it "should be able to edit admin, coordinator,producer status" do
      @another_user = Factory(:user, :id => @user.id + 20, :email => "example20@example.com")
      @another_user.save
      get :edit, :id => @user.id + 20
      response.body.should have_field("user[admin]")
      response.body.should have_field("user[coordinator]")
      response.body.should have_field("user[producer]")
      
    end
  end

  describe "for coordinators" do
    before(:each) do
      @user = test_sign_in(Factory(:user, :coordinator => true))
    end

    it "should succeed given correct index" do 
      get :edit, :id => @user.id
      response.should be_success
    end

    it "should succeed given member or producer but not an admin" do   
      @another_user = Factory(:user, :id => @user.id + 20, :email => "example20@example.com")
      @admin_user = Factory(:user, :id => @user.id + 21, :email => "example21@example.com", :admin => true)
      get :edit, :id => @user.id + 20
      response.should be_success
      assigns(:user).should eq(@another_user)
      get :edit, :id => @user.id + 21
      response.should redirect_to(@user)
    end

    it "should be able to edit coordinator,producer status" do
      @another_user = Factory(:user, :id => @user.id + 20, :email => "example20@example.com")
      @another_user.save
      get :edit, :id => @user.id + 20
      response.body.should_not have_field("user[admin]")
      response.body.should have_field("user[coordinator]")
      response.body.should have_field("user[producer]")
    end
  end
end



  describe "POST create" do

    describe "success for non-admins" do

      before(:each) do
      @attr = Factory.attributes_for(:user_properties)
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
      @attr = Factory.attributes_for(:user_properties)
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
        @attr = Factory.attributes_for(:user_properties, password_confirmation:"")
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

    before(:each) do
      @user = Factory(:user)
    end

    describe "for admins" do

    before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
  end

  describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(login_path)
      end
    end
    
    describe "as non-admin user" do
      it "should protect the action" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(@user)
      end
    end
    describe "For coordinator" do
      it "should protect the action" do
        @coordinator = Factory(:user, :coordinator => true, :email => "coord@example.com")
        test_sign_in(@coordinator)
        delete :destroy, :id => @user
        response.should redirect_to(@coordinator)
      end
    end
end

  describe "GET editpassword" do
    describe "for non-signed-in users" do
    
    it "should deny access" do
      @another_user = Factory(:user, :id => 38)
      get :editpassword, :id => "38"
      response.should redirect_to(login_path)
    end
  end

   describe "for signed_in users" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    it "should succeed given correct index" do 
      get :editpassword, :id => @user.id
      response.should be_success
    end

    it "should succeed given any index" do 
      get :editpassword, :id => @user.id + 20
      response.should be_success
      assigns(:user).should eq(@user)
    end
  end
  end

 describe "PUT updatepassword" do

    describe "for signed-in users" do
    
    describe "failure" do
      before(:each) do
        @user = Factory(:user, :id => "38")
        test_sign_in(@user)
      end
            
      it "should render the 'editpassword' page for mismatched passwords" do
        @attr = {:old_password => @user.password, :password => "abcdabcd", :password_confirmation => "BLAHBLAH"}
        put :updatepassword, :id => @user, :user => @attr
        response.should render_template('editpassword')
      end
      
       it "should render the 'editpassword' page for incorrect old password" do
        @attr = {:old_password => "WRONGPASSWORD", :password => "abcdabcd", :password_confirmation => "abcdabcd"}
        put :updatepassword, :id => @user, :user => @attr
        response.should render_template('editpassword')
      end

    end

    describe "success" do
      before(:each) do
        @user = Factory(:user, :id => "38")
        test_sign_in(@user)
      end
      
      before(:each) do
        @attr = { :old_password => @user.password, :password => "password", :password_confirmation => "password"}
      end
      
      it "should change the user's password" do
        @old_encrypted_password = @user.encrypted_password
        put :updatepassword, :id => @user, :user => @attr
        @user.reload
        @user.encrypted_password.should_not == @old_encrypted_password
        response.should redirect_to(@user)
      end
    end
  end

  

  # describe "GET adduser" do

  #   describe "called by admin" do
  #     it "should have a page at /users/:id/adduser"
      

  end
end
