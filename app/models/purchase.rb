class Purchase < ActiveRecord::Base
  attr_accessible :item_id, :quantity, :inventory_id, :unit_price, :user_id, :paid, :order_set, :created_at, :markup_price

  belongs_to :item
  belongs_to :user
  belongs_to :inventory

  after_create :set_inventory_id

  before_save :increment_total_ordered

  before_destroy :decrement_total_ordered

  def set_inventory_id
    self.inventory_id = Item.find(self.item_id).inventory_id
    self.save
  end

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

  def self.markup_price
    total = 0
    Purchase.where("paid = ?", false).each {|purchase| total += purchase.item.markup_price}
    return total
  end 

  def self.handling_fee
    self.total_payment - self.subtotal_payment
  end

  def self.pending_payment
    total = 0
    Purchase.where("paid = ?", false).each {|purchase| total += purchase.item.markup_price * purchase.quantity}
    return total
  end

  def self.total_payment
    total = 0
    Purchase.all.each {|purchase| total += purchase.item.markup_price* purchase.quantity}
    return total
  end

  def self.subtotal_payment
    total = 0
    Purchase.all.each {|purchase| total += purchase.full_price}
    return total
  end

  def self.processed_payment
    total = 0
    Purchase.where("paid = ?", true).each {|purchase| total += purchase.item.markup_price}
    return total
  end

  def self.create_purchases(cart, paid, transaction)
      
      if(transaction.nil?)
        transaction = "unpaid"
      end

      ret = true
      cart.cart_items.each do |cart_item|
        @purchase = Purchase.new(:item_id => cart_item.item_id, 
               :user_id => cart.user.id,
               :quantity => cart_item.quantity,
               :unit_price => cart_item.item.price,
               :paid => paid,
               :order_set => transaction)
        @purchase.save
      end
  end

end
