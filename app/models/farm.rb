class Farm < ActiveRecord::Base
	belongs_to :user, :foreign_key => "id" #a user's "id" column is the foreign key
					  # :autosave => false 
	has_many :inventory, :foreign_key => "farm_id", :autosave => true

	# before_save :not_farmer?

	attr_accessible :url, :description

private

	def not_farmer?
		self.description = "asdfasdf" unless user.farmer?
	end

end
