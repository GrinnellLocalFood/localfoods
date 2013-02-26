class Category < ActiveRecord::Base

	has_many :items, :foreign_key => "category_id"

	attr_accessible :name
	
	validates :name, :presence => true,
                    :uniqueness =>  { :case_sensitive => false, 
                    	:message => "of category is already in use."}

end
