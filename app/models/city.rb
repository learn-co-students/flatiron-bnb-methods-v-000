require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(date_one,date_two)
    listings = self.listings
    range = date_one..date_two
    dates = []

    listings.each do |listing|
      flag = true
      listing.reservations.each do |reservation|
        reserve_dates = reservation.checkin..reservation.checkout
        if range.overlaps?(reserve_dates)
          flag = false
        end
      end
      dates << listing unless flag == false
    end

    dates
  end

  def self.highest_ratio_res_to_listings
    cities = self.all 
    ratio = {}
    cities.each do |city|
      listing_count = city.listings.count
      reservation_count = city.reservations.count
      ratio[city.name] = (reservation_count/listing_count.to_f) 
    end
    # puts ratio.to_s
    highest = ratio.max_by{|key,value| value} #highest will be in the form [key,value] so [city_name,ratio_number]
    self.find_by(name: highest[0])
  end

  def self.most_res
    cities = self.all 
    reservation_counts = {}

    cities.each do |city|
      number_of_res = city.reservations.count
      reservation_counts[city.name] = number_of_res
    end

    most = reservation_counts.max_by{|key,value| value}
    self.find_by(name: most[0])
  end

end

