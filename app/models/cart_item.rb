class CartItem < ActiveRecord::Base
 	belongs_to :cart
 	belongs_to :item
 	validates :cart, :presence => true
  validates :item, :presence => true
  validates :quantity, :numericality => { :only_integer => true, :message => I18n.t('validation.must_be_int'), :greater_than => -1 }
  validate :quantity_greater_than_minorder, :unless => "errors.any?"
  validate :quantity_less_than_maxorder, :unless => "errors.any?"
  validate :quantity_is_available, :unless => "errors.any?"

  

 	attr_accessible :quantity,
 					:cart_id,
 					:item_id,
          :cart,
          :item

 	def full_price
 		item.price * quantity
 	end

  def markup_price
    item.markup_price * quantity
  end

 	def quantity_greater_than_minorder
 		errors.add(:quantity, "entered is smaller than the minimum order which is  #{item.minorder}") unless item.minorder <= quantity
  end

  def quantity_less_than_maxorder
    if !item.maxorder.nil?
  	 errors.add(:quantity, "entered is greater than the maximum order which is #{item.maxorder}") unless item.maxorder >= quantity
    end
  end

  def quantity_is_available
    errors.add(:quantity, "is not available. Remaining available quantity is #{item.num_remaining}") unless item.num_remaining >= quantity
  end

  def still_available?
    item.num_remaining >= quantity && item.minorder <= quantity && (item.maxorder.nil? || item.maxorder >= quantity)
  end

  def find_quantity_available
    item.maxorder.nil? || (item.num_remaining < item.maxorder) ? item.num_remaining : item.maxorder
  end

end
