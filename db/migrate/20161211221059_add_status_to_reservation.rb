class AddStatusToReservation < ActiveRecord::Migration
  def change
    add_column :listings, :status, :string, default: 'pending'
  end
end
