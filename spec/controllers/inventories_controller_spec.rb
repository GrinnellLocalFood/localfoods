require 'spec_helper'

describe InventoriesController do
	before(:each) do
    @attr = { :first_name => "Example", 
              :last_name => "User", 
              :email => "user@example.com", 
              :password => "password",
              :password_confirmation => "password",
          	  :producer => true}
    @user = User.create!(@attr)
  end

  render_views

  describe "GET show" do
    describe "for non-signed-in users" do
    
    it "should succeed" do
      get :show, :id => @user.id
      response.should be_success
    end
  end

  describe "for signed-in users" do
    
    it "should succeed" do
      get :show, :id => @user.id
      response.should be_success
    end
  end

 end

end
