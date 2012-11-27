class Item < ActiveRecord::Base
	belongs_to :inventory, :foreign_key => "inventory_id"
end
