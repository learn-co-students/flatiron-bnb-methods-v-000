class AddHostIdToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :host_id, :integer
  end
end
