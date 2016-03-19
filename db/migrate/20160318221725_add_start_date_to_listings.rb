class AddStartDateToListings < ActiveRecord::Migration
  def change
    add_column :listings, :start_date, :datetime
  end
end
