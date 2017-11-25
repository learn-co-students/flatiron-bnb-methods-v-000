class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin_date, checkout_date)
    Listing.available(checkin_date,checkout_date).uniq & self.city.listings
  end

  def self.highest_ratio_res_to_listings
    reservations = {}
    self.all.each do |neighborhood|
      reservation_count = 0
      neighborhood_listing_count = 0
      neighborhood_listing_count += neighborhood.city.listings.count
      neighborhood.city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      reservations[neighborhood.id] = (reservation_count / neighborhood_listing_count).to_f
    end
    Neighborhood.find(reservations.max_by{ |k,v| v}.first)
  end

  def self.most_res
    reservations = {}

    self.all.each do |neighborhood|
      reservation_count = 0
      neighborhood.city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      reservations[neighborhood.id] = reservation_count
      end
    Neighborhood.find(reservations.max_by{ |k,v| v}.first)
  end

end
