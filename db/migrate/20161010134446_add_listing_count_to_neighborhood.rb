class AddListingCountToNeighborhood < ActiveRecord::Migration
  def change
    add_column :neighborhoods, :listings_count, :integer
  end
end
