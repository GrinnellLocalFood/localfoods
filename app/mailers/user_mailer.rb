class UserMailer < ActionMailer::Base
	require 'socket'
  default :from => "gulatiak@grinnell.edu"

  def welcome_email(host, user, adminAdded)
    @admin_added = adminAdded
    @user = user
    @url = "http://" + host + login_path
    mail(:to => user.email, :subject => "Welcome to Grinnell Local Foods")
  end

  def password_reset(user)
  	@user = user
  	mail(:to => user.email, :subject => "Reset Password")
  end

  def order_status_change(user, email_text, orders_open)
    @user = user
    @text = email_text
    if(orders_open)
      subject = "Orders are now open!"
    else
      subject = "Orders are now closed!"
    end
    mail(:to => user.email, :subject => subject)
  end
end
