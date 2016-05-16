class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  include Concerns::Sortable

   def neighborhood_openings(start_date, end_date)
    listings.each do |listing|
      listing.reservations.select do |res|
        !(res.checkin..res.checkout).overlaps?(start_date.to_date..end_date.to_date)
      end
    end
  end
  			
end
