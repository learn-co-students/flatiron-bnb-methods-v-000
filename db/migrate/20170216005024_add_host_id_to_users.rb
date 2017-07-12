class AddHostIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :host_id, :integer
  end
end
