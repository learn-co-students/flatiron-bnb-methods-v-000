class ChangeHostInUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :host
  	add_column :users, :is_host, :boolean, default: false
  end
end
