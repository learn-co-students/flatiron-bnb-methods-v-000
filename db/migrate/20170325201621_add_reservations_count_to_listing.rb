class AddReservationsCountToListing < ActiveRecord::Migration
  def change
    add_column :listings, :reservations_count, :integer
  end
end
