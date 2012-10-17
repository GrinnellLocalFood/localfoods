class SessionsController < ApplicationController
	def new
		@title = "Log in"
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
			redirect_to signup_path
		end
	end

end
