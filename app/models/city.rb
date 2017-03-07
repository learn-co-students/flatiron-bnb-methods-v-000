class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings


  def city_openings(checkin, checkout)
    arr = []
    listings.each do |listing|
      listing.reservations.each do |reservation|
        if (Date.parse(checkin) <= reservation.checkout) && (Date.parse(checkout) >= reservation.checkin)
          arr << listing
        end
      end
    end
    arr
  end

  def self.most_res
    most_res = City.first
    City.all.each do |city|
      if most_res.reservations.length < city.reservations.length
         most_res = city
       end
     end
    most_res
  end

  def self.highest_ratio_res_to_listings
    store = City.first
    City.all.each do |city|
      if (store.reservations.length / store.listings.length) < (city.reservations.length / city.listings.length)
         store = city
       end
     end
    store
  end





end
