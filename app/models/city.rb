require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(date1, date2)
    date1 = Date.parse(date1)
    date2 = Date.parse(date2)
    available_listings = []
    listings.map do |listing| 
      if listing.reservations.none? { |res|  res.checkin.between?(date1, date2) && res.checkout.between?(date1, date2) }
        available_listings << listing
      end
    end
    available_listings
  end


  def self.highest_ratio_res_to_listings
    highest_ratio_city = ""
    highest_ratio = 0

    self.all.map do |city|
      listings_num = city.listings.count
      reservations_num = city.listings.map { |listing| listing.reservations}.flatten.count
      city_ratio = reservations_num/listings_num.to_r

      if city_ratio  > highest_ratio
        highest_ratio_city = city
        highest_ratio = city_ratio 
      end
    end
    highest_ratio_city
  end

    def self.most_res
    most_res_city = ""
    most_res = 0

    self.all.map do |city|
      reservations_num = city.listings.map { |listing| listing.reservations}.flatten.count

      if reservations_num  > most_res
        most_res_city = city
        most_res = reservations_num 
      end
    end
    most_res_city
  end


end

