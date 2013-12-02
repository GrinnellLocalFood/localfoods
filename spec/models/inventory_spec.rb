require 'spec_helper'

describe Inventory do

  before(:each) do
    @attr = Factory.attributes_for(:user)
  end

  it "should create a producer possessing a inventory with the correct id" do
    producer = User.new(@attr.merge(:producer => true))
    producer.save
    producer.inventory.should_not be_nil
    Inventory.find(producer.id).should eql(producer.inventory)
  end

  it "should add a inventory for a user who is changed to a producer" do
    user = User.new(@attr) #non-producer
    user.save!
    user.producer = true
    user.save
    user.inventory.should_not be_nil
    Inventory.find(user.id).should eql(user.inventory)
  end

  it "should not delete a inventory for a user who is no longer a producer" do
    user = User.new(@attr.merge(:producer => true)) #producer
    user.save!
    user.producer = false
    user.save
    user.inventory.should_not be_nil
  end

  it "should be able to set attributes of a inventory" do
    producer = User.create!(@attr.merge(:producer => true))
    producer.inventory.url = "url"
    producer.inventory.description = "description"
    producer.save
    inventory = Inventory.find(producer.id)
    inventory.url.should eq("url")
    inventory.description.should eq("description")
  end

  it "should set a defaut display name for the inventory" do
    producer = User.create!(@attr.merge(:producer => true))
    producer.save
    inventory = Inventory.find(producer.id)
    inventory.display_name.should eq(producer.first_name + " " + producer.last_name)
  end

  it "should not give a non-producer a inventory" do
    non_producer = User.create(@attr)
    non_producer.inventory.should eq(nil)
  end
  

end