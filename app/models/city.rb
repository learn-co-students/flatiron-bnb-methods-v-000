class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin_date, checkout_date)
    Listing.available(checkin_date,checkout_date).uniq & self.listings
  end

  def self.highest_ratio_res_to_listings
    reservations = {}
    self.all.each do |city|
      reservation_count = 0
      city_listing_count = 0
      city_listing_count += city.listings.count
      city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      reservations[city.id] = (reservation_count / city_listing_count).to_f
    end
    City.find(reservations.max_by{ |k,v| v}.first)
  end

  def self.most_res
    reservations = {}

    self.all.each do |city|
      reservation_count = 0
      city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      reservations[city.id] = reservation_count
      end
    City.find(reservations.max_by{ |k, v| v}.first)
  end


end

