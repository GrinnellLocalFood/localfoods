require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :user_id => -1, :first_name => "Example", :last_name => "User", :email => "user@example.com", :password => "password"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require first name" do
    no_name_user = User.new(@attr.merge(:first_name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require last name" do
    no_name_user = User.new(@attr.merge(:last_name => ""))
    no_name_user.should_not be_valid
  end

end
