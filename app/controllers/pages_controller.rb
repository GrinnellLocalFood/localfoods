class PagesController < ApplicationController
	skip_before_filter :require_login

  def home
  	@title = "Home"
  end

  

end
