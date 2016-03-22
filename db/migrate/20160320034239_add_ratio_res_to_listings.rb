class AddRatioResToListings < ActiveRecord::Migration
  def change
    add_column :listings, :ratio_res, :float
  end
end
