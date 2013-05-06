class AddAnnouncementsToApplicationState < ActiveRecord::Migration
   def self.up
  	add_column :application_states, :announcements, :text
  	add_column :application_states, :pickup_info, :text
  	add_column :application_states, :about, :text
  end

  def self.down
  	remove_column :application_states, :announcements
  	remove_column :application_states, :pickup_info
  	remove_column :application_states, :about
  end
end
