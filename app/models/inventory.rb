class Inventory < ActiveRecord::Base
	belongs_to :user, :foreign_key => "id" #a user's "id" column is the foreign key
					  # :autosave => false 
	has_many :item, :foreign_key => "inventory_id", :autosave => true

    has_attached_file :photo, :styles => {:small => "150x150>"}
	attr_accessible :url, :description, :display_name, :photo

end
