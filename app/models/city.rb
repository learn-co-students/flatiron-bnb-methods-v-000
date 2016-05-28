require_relative '../../lib/ratios_extension.rb'

class City < ActiveRecord::Base
  #extend RatiosExtension

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(date1, date2)
    #binding.pry
    self.reservations.collect do |reservation| 
      range = reservation.checkin..reservation.checkout
      if range === date1 || range === date2 
        nil
      else
        reservation.listing
        #binding.pry
      end
    end
  end

  def self.most_res
    self.all.max_by {|city| city.reservations.length}
  end

  def self.highest_ratio_res_to_listings
    city = self.all.max_by {|city| city.listings.length}
    self.most_res.reservations.length > city.listings.length ? self.most_res : city
  end

end
