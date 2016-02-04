require_relative './concerns/area_stats.rb'

class City < ActiveRecord::Base
  extend AreaStats
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
  
  def city_openings(checkin,checkout)
    listings.select do |listing|
      open = true
      date = Date.parse(checkin)
      until date == Date.parse(checkout)
        open = false if listing.not_available_dates.include?(date)
        date += 1
      end
      open
    end
  end

end

