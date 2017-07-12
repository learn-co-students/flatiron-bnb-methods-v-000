class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings


  def neighborhood_openings(startdate, enddate)
    startdate = Date.parse startdate
    enddate = Date.parse enddate
    city_openings = []
    listings.each do |listing|
      city_openings << listing if !listing.reservations.any? {|reservation| reservation.checkin <= enddate && reservation.checkout >= startdate }
    end
    city_openings
  end

  def self.highest_ratio_res_to_listings
    sorted  = self.all.sort_by do |neighborhood|
      if neighborhood.reservations.count * neighborhood.listings.count != 0
        neighborhood.reservations.count.to_f / neighborhood.listings.count.to_f
      else
        0
      end
    end
    highestratio = sorted.reverse.first
  end

  def self.most_res
    sorted = self.all.sort_by { |city| city.reservations.count }.reverse
    mostres = sorted.first
  end

end
