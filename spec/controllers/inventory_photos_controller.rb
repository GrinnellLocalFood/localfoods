require 'spec_helper'

describe InventoryPhotosController do

describe "DELETE destroy" do

  before(:each) do
      @user = test_sign_in(Factory(:user, :producer => true))
      @inventory_photo = InventoryPhoto.new(:photo => File.new(Rails.root + 'spec/fixtures/images/validimage.gif'))
      @inventory_photo.inventory_id = @user.inventory.id
      @inventory_photo.save
    end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @inventory_photo
        end.should change(InventoryPhoto, :count).by(-1)
      end
      
      it "should redirect to the current user edit page" do
        delete :destroy, :id => @inventory_photo
        response.should redirect_to(edit_user_path(@user))
      end
    
  end

end