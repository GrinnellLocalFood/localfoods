require 'spec_helper'

describe ItemsController do  
  
describe "For non-signed in users" do

  describe "GET 'new'" do
    it "should redirect to login page" do
      get 'producer_new'
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

end
