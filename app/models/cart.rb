class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :cart_items
  belongs_to :user, :foreign_key => "user_id"
  accepts_nested_attributes_for :cart_items, :update_only => true

  def total_price
  	cart_items.to_a.sum(&:full_price)
  end
end
