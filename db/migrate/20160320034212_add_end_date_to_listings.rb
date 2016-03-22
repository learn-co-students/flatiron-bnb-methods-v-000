class AddEndDateToListings < ActiveRecord::Migration
  def change
    add_column :listings, :end_date, :datetime
  end
end
