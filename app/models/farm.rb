class Farm < ActiveRecord::Base
	belongs_to :user, :foreign_key => "id" #a user's "id" column is the foreign key
					  #:autosave => false 

	before_save :not_farmer?

private

	def not_farmer?
		self.description = "asdfasdf" unless user.farmer?
	end

end
