class AddRatioResToListingsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :ratio_res_to_listings, :float
  end
end
