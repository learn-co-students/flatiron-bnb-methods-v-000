class City < ActiveRecord::Base
  include Shared
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(starting, ending)
    results = []
    start_date = Date.parse(starting)
    end_date = Date.parse(ending)
    self.listings.each do |listing|
      valid = true
      listing.reservations.each do |reservation|
        if !(reservation.checkin > end_date || reservation.checkout < start_date)
          valid = false
        end
      end
      if valid
        results << listing
      end
    end
    results
  end

  def self.highest_ratio_res_to_listings
    high = 0
    return_object = nil
    self.all.each do |object|
      listings = object.listings.count
      reservations = 0
      object.listings.all.each do |listing|
        reservations += listing.reservations.count
      end
      if listings > 0
        ratio = reservations / listings
        if ratio > high
          return_object = object
          high = ratio
        end
      end
    end
    return_object
  end

  def self.most_res
    high = 0
    return_object = nil
    self.all.each do |object|
      reservations = 0
      object.listings.all.each do |listing|
        reservations += listing.reservations.count
      end
      #binding.pry
      if reservations >= high
        return_object = object
        high = reservations
      end
    end
    return_object
  end

end
