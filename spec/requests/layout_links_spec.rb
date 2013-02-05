require 'spec_helper'

describe "LayoutLinks" do

	it "should have a Home page at '/'" do
		visit '/'
		page.should have_text("Home")
	end

	it "should have a Register page at register_path" do
		visit register_path
		page.should have_text("Register")
	end

	it "should have a Login page at login_path" do
		visit login_path
		page.should have_text("Log In")
	end

	describe "when not logged in" do
		it "should have a login link" do
			visit '/'
			page.should have_button("Log In")
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
				page.should have_link("Log Out", :href => logout_path)
			end

		end

		end
	end