class PaymentNotificationsController < ApplicationController
	protect_from_forgery :except => [:create]
	skip_before_filter :require_login, :only => [:create]

	def create
  		#PaymentNotification.create!(:params => params, :cart_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:txn_id])
  		PaymentNotification.create_purchases(params, current_user)
  		redirect_to current_user
	end

end
