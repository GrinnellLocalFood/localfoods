class PaymentNotification < ActiveRecord::Base
  attr_accessible :cart_id, :params, :status, :transaction

  belongs_to :cart
  serialize :params
  after_create :create_purchases


	def create_purchases
		cart = Cart.find(cart_id)
		if(status == "Completed")
			Purchase.create_purchases(cart, true, transaction)
		end		
	end

end
