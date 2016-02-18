class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(from, to)
    from = DateTime.parse(from)
    to = DateTime.parse(to)
    Listing.all.select do |listing|
      listing.reservations.detect do |res|
        res.checkin.between?(from, to) || res.checkout.between?(from, to)
      end.nil?
    end
  end

  def self.highest_ratio_res_to_listings
    # should return the City that is "most full".
    # What that means is it has the highest amount of reservations per listing

  end

  def self.most_res
    # return the City with the most total number of reservations,
    # no matter if they are all on one listing or otherwise
    self.all.sort_by do |city|
      city.listings.collect do |listing|
        listing.reservations.count
      end.reduce(:+)
    end.last
  end
end
