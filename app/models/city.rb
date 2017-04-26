class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
  validates :name, presence: true

  def city_openings(startdate, enddate)
    startdate = Date.parse startdate
    enddate = Date.parse enddate
    city_openings = []
    listings.each do |listing|
      city_openings << listing if !listing.reservations.any? {|reservation| reservation.checkin <= enddate && reservation.checkout >= startdate }
    end
    city_openings
  end

  def self.highest_ratio_res_to_listings
    sorted  = self.all.sort_by { |city| city.reservations.count.to_f / city.listings.count.to_f}.reverse
    highestratio = sorted.first
  end

  def self.most_res
    sorted = self.all.sort_by { |city| city.reservations.count }.reverse
    mostres = sorted.first
  end
end
