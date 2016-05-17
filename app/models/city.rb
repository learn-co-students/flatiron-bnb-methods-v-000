class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(checkin, checkout)
    listings = []
    self.listings.each do |x|
      listings<<x if x.check_availability(checkin,checkout) == []
      binding.pry
    end
    listings
  end

  def self.most_res


    city = 0
    number = 0
    City.all.each do |x|
      if x.reservations.count > number
        city = x.id
        number = x.reservations.count
      end
    end
    City.find(city)
  end

  def self.highest_ratio_res_to_listings
    @cities = City.all.includes(:reservations, :listings)
    cid = 0
    ratio = 0
    @cities.all.each do |x|
      if x.reservations.count.to_f / x.listings.count.to_f > ratio
        ratio = x.reservations.count.to_f / x.listings.count.to_f
        cid = x.id
      end
    end
    City.find(cid)
  end

end

