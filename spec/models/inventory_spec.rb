require 'spec_helper'

describe Inventory do
   before(:each) do
    @attr = { :id => -1, 
              :first_name => "Example", 
              :last_name => "User", 
              :email => "user@example.com", 
              :password => "password",
              :password_confirmation => "password"}
    @item = { :name => "Apple" }
  end

  it "should allow a farmer to add multiple inventory items" do
  	farmer = User.create!(@attr.merge(:farmer => true))
  	@item1 = Inventory.new(@item.merge(:description => "apple1"))
  	@item2 = Inventory.new(@item.merge(:description => "apple2"))
  	farmer.farm.inventory << @item1
  	farmer.farm.inventory << @item2
  	farmer.farm.inventory.count.should eq(2)
  end

  it "should allow a farmer to delete inventory" do
  	farmer = User.create!(@attr.merge(:farmer => true))
  	@item1 = Inventory.new(@item.merge(:description => "apple1"))
  	@item2 = Inventory.new(@item.merge(:description => "apple2"))
  	farmer.farm.inventory << @item1
  	farmer.farm.inventory << @item2
  	farmer.farm.inventory.delete(@item1)
  	farmer.farm.inventory.where("description = ?","apple1").first.should be_nil
  	farmer.farm.inventory.where("description = ?","apple2").first.should_not be_nil
  end 

  it "should allow a farmer to edit inventory" do
    farmer = User.create!(@attr.merge(:farmer => true))
    @item1 = Inventory.new(@item.merge(:description => "apple1"))
    farmer.farm.inventory << @item1
    edited_item = farmer.farm.inventory.where("description = ?","apple1").first
    edited_item.description = "new desc"
    edited_item.save
    farmer.farm.inventory.where("description = ?","new desc").first.should_not be_nil
  end 

end

