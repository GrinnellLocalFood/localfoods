class ApplicationState < ActiveRecord::Base

	attr_accessible :orders_open, :email_content, :email_signoff, :email_users, :clear_carts, :announcements, :pickup_info, :about
	attr_accessor :email_content, :email_subject, :email_users, :clear_carts

	def self.get_state
		create_row_if_absent
		ApplicationState.first
	end

	#returns yes/no
	def self.orders_open
		if self.orders_open?
			"Yes"
		else
			"No"
		end
	end

	#return boolean
	def self.orders_open?
		create_row_if_absent
		ApplicationState.first.orders_open
	end

	def self.about_text
		return "" if ApplicationState.first.nil?
		ApplicationState.first.about
	end

	def self.announcements
		return "" if ApplicationState.first.nil?
		ApplicationState.first.announcements
	end

	def self.pickup_info_text
		return "" if ApplicationState.first.nil?
		ApplicationState.first.pickup_info
	end

	private
	def self.create_row_if_absent
		if(ApplicationState.first.nil?)
			state = ApplicationState.new
			state.save
		end
	end
end
