class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(startdate, enddate)
    span1 = DateTime.parse(startdate)
    span2 = DateTime.parse(enddate)

    available_listings = []

    Listing.all.each do |listing|

      reservations = []
      listing.reservations.each do |reservation|

        if reservation.checkout > span1 && reservation.checkin < span2
          reservations << reservation
        end

      end

      if reservations.empty?
        available_listings << listing
      end
    end
    available_listings
  end


  def self.highest_ratio_res_to_listings
    # City.first.listings.count Gives the number of listings of specific city
    # ratio_hash["New York City"] = {"listings" => city.listings.count}

    ratio_hash = {}

    City.all.each do |city|
      ratio_hash[city.name] = {:listings => city.listings.count}
      x = 0
        city.listings.each do |listing|
          x = x+listing.reservations.count
        end
      ratio_hash[city.name][:reservations] = x
      ratio_hash[city.name][:ratio] = Rational(ratio_hash[city.name][:reservations], ratio_hash[city.name][:listings])
    end

    highest_ratio = {"Test" => -1}
    ratio_hash.each do |city|
      if city[-1][:ratio] > highest_ratio.first[-1]
        city_name = city[0]
        city_ratio = city[-1][:ratio]
        highest_ratio = {city_name => city_ratio}
      end
    end
    City.find_by(name: highest_ratio.first.first)
  end

  def self.most_res
    most_res = {"test" => -1}

    City.all.each do |city|
      x = 0
      city.listings.each do |listing|
        x = x+listing.reservations.count

        if x > most_res.first[-1]
          most_res = {city.name => x}
        end
      end
    end
    City.find_by(name: most_res.first.first)
  end


# This is what I want my hash to be
# ratio_hash = {
#   "NYC" => {
#     listings: 4
#     reservation: 3
#   }
#   "San Francisco" => {
#     listing: 2
#     reservation: 1
#   }
# }








end






