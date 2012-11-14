require 'spec_helper'

describe Farm do

  before(:each) do
    @attr = { :user_id => -1, 
              :first_name => "Example", 
              :last_name => "User", 
              :email => "user@example.com", 
              :password => "password",
              :password_confirmation => "password"}
  end

  it "should destroy itself if its user is no longer a farmer" do
  	user = User.create!(@attr.merge(:farmer => true))
  	user.farmer = false
  	user.save
  	Farm.find(user.id).should be_nil
  end
end