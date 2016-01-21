class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(begin_date, end_date)
    @openings = []
    checkin_date = Date.parse(begin_date)
    checkout_date = Date.parse(end_date)
    listings.each do |listing|
      @openings << listing unless listing.reservations.any? do |reservation|
        checkin_date.between?(reservation.checkin, reservation.checkout) && checkout_date.between?(reservation.checkin, reservation.checkout)
      end
    end
    @openings
  end

  def self.highest_ratio_res_to_listings
    @city_reservation_ratio = {}
    self.all.each do |location|
      if location.listings.count != 0 && location.reservations.count != 0
        total_listings = location.listings.count
        total_reservations = location.reservations.count
        ratio = total_reservations/total_listings
        @city_with_highest_ratio = location if ratio > (@city_reservation_ratio.values[0] || 0)
        @city_reservation_ratio[location] = ratio
      end
    end
    @city_with_highest_ratio
  end

  def self.most_res
    @city_with_most_reservations = {"location" => 0}
    self.all.each do |location|
      total_reservations = location.reservations.count
      @city_with_most_reservations = {location => total_reservations } if total_reservations > @city_with_most_reservations.values[0]
    end
    @city_with_most_reservations.keys[0]
  end
end
