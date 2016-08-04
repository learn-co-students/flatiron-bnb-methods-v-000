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

  def self.highest_ratio_res_to_listings
    max = 0
    max_res = 0
    @save_res_city = nil
    save = nil
    City.all.each do |city|
      neighborhood_ids = Neighborhood.where(city_id: city.id).pluck(:id)
      listings = Listing.where(neighborhood_id: neighborhood_ids)
      reservation_count = 0
      listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      if reservation_count > max_res
        max_res = reservation_count
        @save_res_city = city
      end
      ratio = reservation_count.to_f/listings.count
      if ratio > max
        max = ratio
        save = city
      end
    end
    save
  end

  def self.most_res
    highest_ratio_res_to_listings
    @save_res_city
  end

end
