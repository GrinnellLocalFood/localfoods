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

  describe "For signed-in users" do
    
    describe "admin" do
      before(:each) do
        @admin = test_sign_in(Factory(:admin))
        @producer = Factory(:producer)
        @item = Factory(:item)
      end

      describe "should be able to add an item" do
        # post :create, { :item => @item, :inventory_id => @producer.inventory.id }
        # @producer.inventory.item.first.description.should eq(@item.description)
      end
    end
  end


end
