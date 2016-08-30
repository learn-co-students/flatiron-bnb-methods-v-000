require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

=begin
  def city_openings(start_date, end_date)
    available_listings = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if start_date.to_date >= reservation.checkout || end_date.to_date <= reservation.checkin
          available_listings << listing
        end
      end
    end
    return available_listings.uniq
  end
=end
  def city_openings(start_date, end_date)
     self.listings.each do |listing|
       listing.reservations.each do |res|
         start_date <= res.checkout.to_s && end_date <= res.checkin.to_s
       end
     end
  end

  def self.highest_ratio_res_to_listings
    @cities = []

    all.each do |city|
      if city.has_listings?
        @cities << city
      end
    end

    @cities.max_by do |city|
      city.reservations.count / city.listings.count
    end
  end

  def has_listings?
    self.listings.any?
  end

  def self.most_res
    self.all.max_by do |city|
      city.reservations.count
    end
  end

end
