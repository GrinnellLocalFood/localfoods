class SessionsController < ApplicationController

	#skip_before_filter :require_login
	
	def new
		@title = "Log In"
	end

	def create
		user = User.authenticate(params[:session][:email],
			params[:session][:password])
		if user.nil?
			flash.now[:error] = "Invalid email/password combination."
			@title = "Log in"
			render 'new'
		else
			sign_in user
			redirect_to user
		end
	end
	def destroy
		sign_out
		redirect_to root_path
	end


end
