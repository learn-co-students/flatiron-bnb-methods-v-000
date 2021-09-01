class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    checkin = checkin.to_date
    checkout = checkout.to_date
    available_listings = []
    self.listings.each do |listing|
      conflicts = listing.reservations.map do |reservation|
        reservation.checkin <= checkout && checkin <= reservation.checkout
      end
      if !conflicts.any?
        available_listings.push(listing)
      end
    end
    return available_listings
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    highest_city = nil

    self.all.each do |city|
      reservations = 0
      curr_ratio = 0.0
      listing_num = city.listings.length

      city.listings.each do |listing|
        reservations += listing.reservations.length
      end

      curr_ratio = reservations / listing_num unless listing_num == 0 || reservations == 0

      if curr_ratio > highest_ratio
        highest_ratio = curr_ratio
        highest_city = city
      end
    end
    highest_city
  end

  def self.most_res
    most_res = 0
    most_city = nil

    self.all.each do |city|
      reservations = 0

      city.listings.each do |listing|
        reservations += listing.reservations.length
      end

      if reservations > most_res
        most_res = reservations
        most_city = city
      end
    end
    most_city
  end
end
