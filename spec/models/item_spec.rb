require 'spec_helper'

describe Item do
   before(:each) do
    @attr = { :id => -1, 
              :first_name => "Example", 
              :last_name => "User", 
              :email => "user@example.com", 
              :password => "password",
              :password_confirmation => "password"}
    @item = { :name => "Apple" }
  end

  it "should allow a producer to add multiple items" do
  	producer = User.create!(@attr.merge(:producer => true))
  	@item1 = Item.new(@item.merge(:description => "apple1"))
  	@item2 = Item.new(@item.merge(:description => "apple2"))
  	producer.farm.item << @item1
  	producer.farm.item << @item2
  	producer.farm.item.count.should eq(2)
  end

  it "should allow a producer to delete item" do
  	producer = User.create!(@attr.merge(:producer => true))
  	@item1 = Item.new(@item.merge(:description => "apple1"))
  	@item2 = Item.new(@item.merge(:description => "apple2"))
  	producer.farm.item << @item1
  	producer.farm.item << @item2
  	producer.farm.item.delete(@item1)
  	producer.farm.item.where("description = ?","apple1").first.should be_nil
  	producer.farm.item.where("description = ?","apple2").first.should_not be_nil
  end 

  it "should allow a producer to edit item" do
    producer = User.create!(@attr.merge(:producer => true))
    @item1 = Item.new(@item.merge(:description => "apple1"))
    producer.farm.item << @item1
    edited_item = producer.farm.item.where("description = ?","apple1").first
    edited_item.description = "new desc"
    edited_item.save
    producer.farm.item.where("description = ?","new desc").first.should_not be_nil
  end 

end

