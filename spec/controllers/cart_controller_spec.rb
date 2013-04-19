require 'spec_helper'

describe CartController do

describe "GET show" do
    describe "for non-signed-in users" do
    
    it "should deny access" do
      get :show, :id => 2
      response.should redirect_to(login_path)
    end
  end

  describe "for signed_in users" do
      before(:each) do
      @user = test_sign_in(Factory(:user))
      @user.cart = Cart.new
    end

    it "should load own cart given correct id" do 
      @id = Cart.find_by_user_id(@user).id
      get :show, :id => (@id)
      response.should be_success
    end

    it "should load own cart given any id" do 
      @id = Cart.find_by_user_id(@user).id
      get :show, :id => (@id + 20)
      response.should be_success
    end
end
end
end
