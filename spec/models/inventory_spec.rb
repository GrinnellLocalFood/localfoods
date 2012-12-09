require 'spec_helper'

describe Inventory do

  before(:each) do
    @attr = { :id => -1, 
              :first_name => "Example", 
              :last_name => "User", 
              :email => "user@example.com", 
              :password => "password",
              :password_confirmation => "password"}    
    @item = { :name => "Apple", 
              :description => "blah",
              :minorder => 5, 
              :maxorder => 15, 
              :price => 4.00, 
              :available => true }
  end

end