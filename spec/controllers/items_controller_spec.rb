require 'spec_helper'

describe ItemsController do  
  
  describe "For non-signed in users" do

    describe "GET 'new'" do
      it "should redirect to login page" do
        get :producer_new, :inventory_id => 5
        response.should redirect_to(login_path)
      end
    end

    describe "GET 'new'" do
      it "should redirect to login page" do
        get 'admin_coord_new'
        response.should redirect_to(login_path)
      end
    end

    describe "PUT 'create'" do
      it "should redirect to login page" do
        put 'create'
        response.should redirect_to(login_path)
      end
    end

    describe "PUT 'destroy'" do
       it "should redirect to login page" do
        put :destroy, :id => 6
        response.should redirect_to(login_path)
      end
    end

    describe "GET 'edit'" do
      it "should redirect to login page" do
        get :edit, :id => 6
        response.should redirect_to(login_path)
      end
    end

    describe "GET 'show'" do
      it "should redirect to login page" do
        get :show, :id => 6
        response.should redirect_to(login_path)
      end
    end
  end

#   describe "For signed-in users" do
#     before(:each) do
#       @attr = { :user_id => -1, 
#         :first_name => "Example", 
#         :last_name => "User", 
#         :email => "user@example.com", 
#         :password => "password",
#         :password_confirmation => "password"}

#       # @admin_attr = @attr.merge(:admin => true)
#       # @producer_attr = @attr.merge(:producer => true)
#       # @coord_attr = @attr.merge(:coordinator => true)
#       # @admin = User.create!(@user_attr)
#       # @producer = User.create!({ :first_name => "b", :last_name => "a", :email => "asdf@asdf.com", :password => "asdfasdf", :password_confirmation => "asdfasdf", :producer => true})
#       # @coordinator = User.create!(@coord_attr)
#       # sign_in @admin
#       end

#     describe "admin" do
      
#       before(:each) do
#       end

#       describe "should be able to add an item" do

#         @admin = Factory(:user, :admin => true, :email => "blah@blah.com")
#         @producer = Factory(:user, :producer => true)
#         post :create, :item => @item #, :inventory_id => @producer.inventory.id }
#         @producer.inventory.item.first.description.should eq(@item.description)

#       end
#     end
#   end


# end
