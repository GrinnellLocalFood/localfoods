class Item < ActiveRecord::Base
	belongs_to :farm, :foreign_key => "farm_id"
end
