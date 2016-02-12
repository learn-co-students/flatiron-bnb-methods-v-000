class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(check_in, check_out)
    min = Date.parse(check_in)
    max = Date.parse(check_out)
    @available = []

    listings.each do |listing|
      @available << listing unless listing.reservations.any? { |reservation| 
        (reservation.checkin.between?(min, max) && reservation.checkout.between?(min, max) ) 
      }
    end
    @available
  end

  def self.highest_ratio_res_to_listings
    ratio_res = {}

    self.all.each do |city|
      if city.listings.count > 0
      counter = 0
      city.listings.each do |x|
        counter += x.reservations.count 
      end
      ratio_res[city] = counter / city.listings.count 
    end
  end
    ratio_res.key(ratio_res.values.sort.last)
  end

  def self.most_res
    most_res = {}

    self.all.each do |city|
      counter = 0
      city.listings.each do |x|
        counter += x.reservations.count 
      end
      most_res[city] = counter 
    end
    most_res.key(most_res.values.sort.last)
  end

end ## class end 

