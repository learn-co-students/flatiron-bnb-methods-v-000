class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(checkin, checkout)
    self.listings.select do |listing|
      listing.reservations.all? do |reservation|
        ((Date.parse(checkin)) >= reservation.checkout) || ((Date.parse(checkout)) <= reservation.checkin)
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by {|city| city.listings.count.zero? ? 0 : city.reservations.count / city.listings.count}
  end

  def self.most_res
    self.all.max {|a, b| a.reservations.count <=> b.reservations.count }
  end
end
