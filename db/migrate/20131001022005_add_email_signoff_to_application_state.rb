class AddEmailSignoffToApplicationState < ActiveRecord::Migration
  def change
    add_column :application_states, :email_signoff, :string
  end
end
