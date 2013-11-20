class PaymentNotification < ActiveRecord::Base
  attr_accessible :cart_id, :params, :status, :transaction_id

  belongs_to :cart
  serialize :params
  after_create :create_purchases


	def self.create_purchases(params, current_user)
		status = params[:st]
		if(status == "Completed")
			#if the payment at paypal was successful, then mark all the users unpaid purchases as paid
			unpaid = Purchase.where("user_id = ? AND paid = ?", current_user.id, false)
			unpaid.each do |purchase|
				purchase.paid = true
				purchase.save!
			end
			#empty their cart
			current_user.cart.clear_all_items
		end		
	end

end
