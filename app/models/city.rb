
require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :neighborhoods

  def city_openings(date1, date2)
    availables = []
    self.listings.each do |listing|
      if listing.reservations.empty?
        availables << listing
      else  listing.reservations.each do |reservation|
        if reservation.checkin >= date2.to_datetime || reservation.checkout <= date1.to_datetime
          availables << reservation.listing
        end
      end
      end
    end
    availables
  end
class << self
  def highest_ratio_res_to_listings
    last_city = ""
    last_ratio = 0.00
    self.all.each do |city|
      if city.listings.count == 0 || city.listings.count == nil
        current_ratio = 0
      else
        current_ratio = city.reservations.count.to_f/city.listings.count.to_f
      end
      if current_ratio >= last_ratio
        last_city = city
        last_ratio = current_ratio
      end
    end
    last_city
  end

  def most_res
    cities = self.all
    cities.detect do |city|
      cities.all? {|test| city.reservations.count >= test.reservations.count}
    end
  end
end
end

