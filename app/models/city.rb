class City < ActiveRecord::Base

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(date1, date2)
    range = date1..date2

    listings.each do |listing|
      listing.reservations.reject {|reservation| reservation != nil || (range === reservation.checkin) || (range === reservation.checkout) }
    end
  end

  def self.most_res
    self.all.max_by {|city| city.reservations.length}
  end

  def self.highest_ratio_res_to_listings
    city = self.all.max_by {|city| city.listings.length}
    self.most_res.reservations.length > city.listings.length ? self.most_res : city
  end

end
