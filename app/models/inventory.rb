class Inventory < ActiveRecord::Base



	belongs_to :user, :foreign_key => "id" #a user's "id" column is the foreign key
					  # :autosave => false 
	has_many :item, :foreign_key => "inventory_id", :autosave => true, :dependent => :destroy

    has_attached_file :photo
	attr_accessible :url, :description, :display_name, :photo, :hidden


	validates :display_name, :presence => true

	before_create :default_display_name

	accepts_nested_attributes_for :user
	#fake-delete an inventory so that it persists even if a user is no longer
	#a producer
	def hide
		self.hidden = true
	end

	private

	def default_display_name
		self.display_name = self.user.first_name + " " + self.user.last_name 
	end
end

