class Purchase < ActiveRecord::Base
  attr_accessible :item_id, :quantity, :unit_price, :user_id, :paid, :order_set, :created_at

  belongs_to :item
  belongs_to :user

  before_save :increment_total_ordered

  before_destroy :decrement_total_ordered

  def increment_total_ordered
    item.totalordered += (quantity - self.changed_attributes['quantity'].to_i)
    item.save
  end  

  def decrement_total_ordered
    item.totalordered -= quantity
    item.save
  end

  def full_price
 		unit_price * quantity
  end

  def self.pending_payment
  	total = 0
  	Purchase.where("paid = ?", false).each {|purchase| total += purchase.full_price}
  	return total
  end

  def self.total_payment
  	total = 0
  	Purchase.all.each {|purchase| total += purchase.full_price}
  	return total
  end

  def self.processed_payment
  	total = 0
  	Purchase.where("paid = ?", true).each {|purchase| total += purchase.full_price}
  	return total
  end

  def self.create_purchases(cart, paid, transaction)
      
      if(transaction.nil?)
        transaction = "unpaid"
      end

      cart.cart_items.each do |cart_item|
        @purchase = Purchase.new(:item_id => cart_item.item_id, 
               :user_id => cart.user.id,
               :quantity => cart_item.quantity,
               :unit_price => cart_item.item.price,
               :paid => paid,
               :order_set => transaction)
        @purchase.save
      end
      cart.clear_all_items
  end

end
