class AddAvailibilityColumnsToListings < ActiveRecord::Migration
  def change
      add_column :listings, :available_from, :date
      add_column :listings, :available_to, :date
  end
end
