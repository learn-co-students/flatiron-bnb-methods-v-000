class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start, finish)
    start = Date.parse(start)
    finish = Date.parse(finish)

    listings.select do |listing|
    listing.reservations.none? do |reservation|
    !((start >= reservation.checkout) || (finish <= reservation.checkin))
    end
   end
  end
  
  def self.highest_ratio_res_to_listings
    highest = City.all[0]
    self.all.each do |city|
      highest = city if (city.reservations.count/city.listings.count.to_f) > (highest.reservations.count/highest.listings.count.to_f)
    end
    highest
  end



  def self.most_res
    most = City.all[0]
    self.all.each do |city|
      most = city if city.reservations.count > most.reservations.count
    end
    most
  end
end
