class CartItem < ActiveRecord::Base
 	belongs_to :cart
 	belongs_to :item
 	validates :cart, :presence => true
  validates :item, :presence => true
  validates :quantity, :numericality => { :only_integer => true, :message => I18n.t('validation.must_be_int'), :greater_than => -1 }
  validate :quantity_greater_than_minorder, :unless => "errors.any?"
  validate :quantity_less_than_maxorder, :unless => "errors.any?"
  validate :quantity_not_available, :unless => "errors.any?"

  before_save :increment_total_ordered

  before_destroy :decrement_total_ordered

 	attr_accessible :quantity,
 					:cart_id,
 					:item_id,
          :cart,
          :item

 	def full_price
 		item.price * quantity
 	end

 	def quantity_greater_than_minorder
 		errors.add(:quantity, "entered is smaller than the minimum order which is  #{item.minorder}") unless item.minorder <= quantity
  end

  def quantity_less_than_maxorder
  	errors.add(:quantity, "entered is greater than the maximum order which is #{item.maxorder}") unless item.maxorder >= quantity
  end

  def quantity_not_available
  		if new_record? 
        errors.add(:quantity, "is not available. Remaining available quantity is #{item.num_remaining}") unless item.num_remaining >= quantity
      else
        errors.add(:quantity, "is not available. Remaining available quantity is #{item.num_remaining}") unless item.num_remaining >= (quantity - self.changed_attributes['quantity'].to_i)
      end
  end

  def increment_total_ordered
    item.totalordered += quantity - self.changed_attributes['quantity'].to_i
    item.save
  end  

  def decrement_total_ordered
    item.totalordered -= quantity
    item.save
  end

end
