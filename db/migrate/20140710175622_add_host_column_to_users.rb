class AddHostColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_host, :boolean, default: false
  end
end
