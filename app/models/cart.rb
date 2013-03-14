class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :cart_items
  belongs_to :user, :foreign_key => "user_id"
  accepts_nested_attributes_for :cart_items, :update_only => true

  def total_price
  	cart_items.to_a.sum(&:full_price)
  end


def paypal_url(return_url)
  values = {
    :business => 'gulati_1362345849_biz@grinnell.edu',
    :cmd => '_cart',
    :upload => 1,
    :returnurl => return_url,
    :noshipping => 1,
    :invoice => id
  }
  cart_items.each_with_index do |item, index|
    values.merge!({
      "amount_#{index+1}" => item.item.price,
      "item_name_#{index+1}" => item.item.name,
      "item_number_#{index+1}" => item.item.id,
      "quantity_#{index+1}" => item.quantity.to_i
    })
  end
  "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
end

def clear_all_items
  cart_items.each do |cart_item|
    cart_item.destroy
  end
end


end
