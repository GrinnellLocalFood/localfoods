class PaymentNotification < ActiveRecord::Base
  attr_accessible :cart_id, :params, :status, :transaction_id

  belongs_to :cart
  serialize :params
  after_create :create_purchases


	def create_purchases

		if(status == "Completed")
			Purchase.create_purchases(cart, true, transaction_id)
		end		
	end

end
