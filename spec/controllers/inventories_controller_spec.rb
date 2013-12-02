require 'spec_helper'

describe InventoriesController do
	before(:each) do
    @user = Factory.create(:user_producer)
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
