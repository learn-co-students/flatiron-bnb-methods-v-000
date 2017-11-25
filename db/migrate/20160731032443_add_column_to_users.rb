class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guest_id, :integer
  end
end
