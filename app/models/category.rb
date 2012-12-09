class Category < ActiveRecord::Base

	has_many :items, :foreign_key => "category_id"

	attr_accessible :name
	
	validates_presence_of :name
end
