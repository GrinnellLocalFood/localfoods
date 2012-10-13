require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :user_id => -1, 
              :first_name => "Example", 
              :last_name => "User", 
              :email => "user@example.com", 
              :password => "password",
              :password_confirmation => "password"}
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

  it "should require a password" do
    no_password_user = User.new(@attr.merge(:password => ""))
    no_password_user.should_not be_valid
  end

  it "should have a minimum password length of 6" do
    short_password_user = User.new(@attr.merge(:password => "asdf"))
    short_password_user.should_not be_valid
  end

  it "should have a maximum password length of 40" do
      long_password_user = User.new(@attr.merge(:password => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"))
      long_password_user.should_not be_valid
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should accept blank display name and replace with 'first last'" do
    no_display_name_user = User.create!(@attr.merge(:display_name => ""))
    no_display_name_user.display_name.should eq(no_display_name_user.first_name  + " " + no_display_name_user.last_name)
  end

  it "should not accept mismatched passwords" do
    mismatched_pwd_user = User.new(@attr.merge(:password_confirmation => "not the same"))
    mismatched_pwd_user.should_not be_valid

end
