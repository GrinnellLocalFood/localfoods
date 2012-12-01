class Inventory < ActiveRecord::Base



	belongs_to :user, :foreign_key => "id" #a user's "id" column is the foreign key
					  # :autosave => false 
	has_many :item, :foreign_key => "inventory_id", :autosave => true, :dependent => :destroy

    has_attached_file :photo
	attr_accessible :url, :description, :display_name, :photo, :hidden


	#fake-delete an inventory so that it persists even if a user is no longer
	#a producer
	def hide
		self.hidden = true
	end
end
