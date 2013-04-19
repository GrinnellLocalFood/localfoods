require 'spec_helper'

describe InventoryPhoto do

  it "image with size 450 X 350 should be valid" do
    image = InventoryPhoto.new(:photo => File.new(Rails.root + 'spec/fixtures/images/validimage.gif'))
    image.should be_valid
  end

  it "image with size 350 X 150 should not be valid" do
    image = InventoryPhoto.new(:photo => File.new(Rails.root + 'spec/fixtures/images/invalidimage.gif'))
    image.should_not be_valid
  end

  it "non-image file should not be valid" do
    image = InventoryPhoto.new(:photo => File.new(Rails.root + 'spec/fixtures/images/invalidphoto.txt'))
    image.should_not be_valid
  end

end