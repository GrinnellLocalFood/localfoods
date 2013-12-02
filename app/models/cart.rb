class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :cart_items
  belongs_to :user, :foreign_key => "user_id"
  accepts_nested_attributes_for :cart_items, :update_only => true

  def subtotal_price
    cart_items.to_a.sum(&:full_price)
  end

  def handling_price
    total_price-subtotal_price
  end

  def total_price
    cart_items.to_a.sum(&:markup_price)
  end

  def paypal_url
    values = {
      :business => 'localfood.seller@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :no_shipping => 1,
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

def paypal_encrypted
  values = {
    :business => APP_CONFIG[:paypal_email],
    :cmd => '_cart',
    :upload => 1,
    :invoice => Purchase.count,
    :no_shipping => 1,
    :cert_id => APP_CONFIG[:paypal_cert_id]
  }
  cart_items.each_with_index do |item, index|
    values.merge!({
      "amount_#{index+1}" => item.item.markup_price,
      "item_name_#{index+1}" => item.item.name,
      "item_number_#{index+1}" => item.item.id,
      "quantity_#{index+1}" => item.quantity.to_i
      })
  end
  encrypt_for_paypal(values)
end

PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert.pem")
APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")

def encrypt_for_paypal(values)
  signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
  OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
end

def clear_all_items
  cart_items.each do |cart_item|
    cart_item.destroy
  end
end

def is_empty?
  cart_items.nil? || cart_items.empty?
end

def invalid_items
  changed_items = Hash.new
  cart_items.all.each do |cart_item|

    if !cart_item.still_available?
      if cart_item.find_quantity_available > 0
        cart_item.quantity = cart_item.find_quantity_available
        changed_items[cart_item.item] = "Quantity available reduced"
        cart_item.save
      elsif cart_item.item.minorder > cart_item.quantity
        changed_items[cart_item.item] = "The minimum order for this item was changed, re-add to cart"
      else
        changed_items[cart_item.item] = "Item no longer available"
        cart_item.destroy
      end
    end
  end
  return changed_items
end

def self.clear_all
  Cart.all.each do |cart|
    cart.clear_all_items
  end
end
end
