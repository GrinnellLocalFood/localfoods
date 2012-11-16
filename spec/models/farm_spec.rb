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

end