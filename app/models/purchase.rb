class Purchase < ActiveRecord::Base
  attr_accessible :item_id, :quantity, :unit_price, :user_id, :paid

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

end
