class UserMailer < ActionMailer::Base
	require 'socket'
  default :from => "gulatiak@grinnell.edu"

  def welcome_email(host, user)
    @user = user
    @url = "http://" + host + login_path
    mail(:to => user.email, :subject => "Welcome to Grinnell Local Foods")
  end

  def password_reset(user)
  	@user = user
  	mail(:to => user.email, :subject => "Reset Password")
  end
end
