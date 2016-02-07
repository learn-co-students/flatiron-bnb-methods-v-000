class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(check_in, check_out) # return Listing objects
    checking_in = Date.parse(check_in)
    checking_out = Date.parse(check_out)

    @open_listings = [] 

    listings.each do |listing|
      @open_listings << listing unless listing.reservations.any? { |reservation|
        checking_in.between?(reservation.checkin, reservation.checkout) && 
        checking_out.between?(reservation.checkin, reservation.checkout) }
        # For each listing, push into @open_listings array unless the check_in and check_out dates entered 
        # by user fall between any of the dates already reserved for that listing
    end
    @open_listings
  end

  def self.highest_ratio_res_to_listings # return City object
    cities = {}
    city = ""

    self.all.each do |city| # for every city
       cities[city] = city.reservations.count / city.listings.count 
    end

    city = cities.key(cities.values.sort.last)
  end

  def self.most_res # return City with most reservations
    city_res = {}
    city = ""

    self.all.each do |city|
      city_res[city] = city.reservations.count.to_i
    end
    city = city_res.key(city_res.values.sort.last)
 
    # out of all the cities
    # we want the one with the most reservations
    # return the City object
  end

end

