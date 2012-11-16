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

  it "should have a minimum phone length of 10" do
    short_phone_user = User.new(@attr.merge(:phone => "123465aaaaaaaaaa"))
    short_phone_user.should_not be_valid
  end

  it "should have a maximum phone length of 15" do
    long_phone_user = User.new(@attr.merge(:phone => "123465671236234762346"))
    long_phone_user.should_not be_valid
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

  it "should not require a password if user info is being updated" do
    User.create!(@attr)
    updated_user = User.first
    updated_user.phone = "1231231231"
    updated_user.first_name = "newfirstname"
    updated_user.save.should eq(true)
  end

  it "should allow the password to be changed" do
    User.create!(@attr)
    change_password_user = User.first
    change_password_user.password = "newpassword"
    change_password_user.password_confirmation = "newpassword"
    change_password_user.save.should eq(true)
  end

  it "should not allow the password to be changed if the password is too short" do
    User.create!(@attr)
    change_password_user = User.first
    change_password_user.password = "short"
    change_password_user.password_confirmation = "short"
    change_password_user.save.should eq(false)
  end

  it "should not allow the password to be changed if the password is too long" do
    User.create!(@attr)
    change_password_user = User.first
    change_password_user.password = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    change_password_user.password_confirmation = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    change_password_user.save.should eq(false)
  end

  it "should create a farmer possessing a farm with the correct id" do
    farmer = User.new(@attr.merge(:farmer => true))
    farmer.save
    farmer.farm.should_not be_nil
    Farm.find(farmer.id).should eql(farmer.farm)
  end

  it "should add a farm for a user who is changed to a farmer" do
    user = User.new(@attr) #non-farmer
    user.save!
    user.farmer = true
    user.save
    user.farm.should_not be_nil
    Farm.find(user.id).should eql(user.farm)
  end

  it "should delete a farm for a user who is no longer a farmer" do
    user = User.new(@attr.merge(:farmer => true)) #farmer
    user.save!
    user.farmer = false
    user.save
    user.farm.should be_nil
    assert_raises (ActiveRecord::RecordNotFound) do
      Farm.find(user.id)
    end
  end

  it "should be able to set attributes of a farm" do
    farmer = User.create!(@attr.merge(:farmer => true))
    farmer.farm.url = "url"
    farmer.farm.description = "description"
    farmer.save
    farm = Farm.find(farmer.id)
    farm.url.should eq("url")
    farm.description.should eq("description")
  end


  it "should not give a non-farmer a farm" do
    non_farmer = User.create(@attr)
    non_farmer.farm.should eq(nil)
  end



end
