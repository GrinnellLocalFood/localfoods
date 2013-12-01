
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :require_login 

  def number_to_currency(number, options = {})
    options[:locale] ||= I18n.locale
    super(number, options)
  end
  def current_cart
    if current_user
      current_cart = Cart.find_by_user_id(current_user)
    end
  end

  private

  def require_login 
    redirect_to login_path unless current_user
  end

end
