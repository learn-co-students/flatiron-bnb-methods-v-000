class CreateTripListings < ActiveRecord::Migration
  def change
    create_table :trip_listings do |t|
      t.integer :trip_id
      t.integer :listing_id

      t.timestamps null: false
    end
  end
end
