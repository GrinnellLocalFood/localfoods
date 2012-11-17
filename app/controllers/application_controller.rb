class ApplicationController < ActionController::Base
	protect_from_forgery
	include SessionsHelper

	before_filter :require_login

	private

	def require_login	
		redirect_to login_path unless current_user
	end

end
