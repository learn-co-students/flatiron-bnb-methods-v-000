class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    neighborhood_ids = Neighborhood.where(city_id: self.id).pluck(:id) #return all neighborhood id in city
    # collect all listings in the neighborhood
    Listing.where(neighborhood_id: neighborhood_ids).collect do |listing|
      if listing.reservations.any? do |reservation|
          (reservation.checkin...reservation.checkout).overlaps?(checkin...checkout)
        end
        nil
      else
        listing
      end
    end
  end

end
