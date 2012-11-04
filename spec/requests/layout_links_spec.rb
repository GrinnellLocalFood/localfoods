require 'spec_helper'

describe "LayoutLinks" do

	it "should have a Home page at '/'" do
		get '/'
		response.should have_selector('title', :content => "Home")
	end

	it "should have a Register page at register_path" do
		get register_path
		response.should have_selector('title', :content => "Register")
	end

	it "should have a Login page at login_path" do
		get login_path
		response.should have_selector('title', :content => "Log In")
	end

	describe "when not logged in" do
		it "should have a login link" do
			visit root_path
			response.should have_selector("a", :href => login_path,
				:content => "Log In")
		end
	end

	describe "when logged in" do

		before(:each) do
			@attr = { :user_id => -1, 
				:first_name => "Example", 
				:last_name => "User", 
				:email => "user@example.com", 
				:password => "password",
				:password_confirmation => "password"}
				@user = User.create!(@attr)
				@user.save
				visit login_path
				fill_in :email,    :with => @user.email
				fill_in :password, :with => @user.password
				click_button
			

			it "should have a logout link" do
				visit root_path
				response.should have_selector("a", :href => logout_path,
					:content => "Log Out")
			end

		end

		end
	end