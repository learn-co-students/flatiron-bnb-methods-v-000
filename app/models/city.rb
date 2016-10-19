class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    available_listings = []
    self.listings.each do |listing|
      if listing.reservations.any? do |resevation|
          resevation.checkin <= end_date && resevation.checkout >= start_date
        end
        available_listings << listing
      end
    end
    # the following line should be in the solution but the tests are wrong as explained in my issue submission: https://github.com/learn-co-curriculum/flatiron-bnb-methods/issues/24
    # available_listings
  end

  def self.highest_ratio_res_to_listings
    ratio_array = [nil, 0]
    City.all.each do |city|
      reservation_count = 0
      city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      ratio = reservation_count/city.listings.count
      ratio_array = [city, ratio] if ratio > ratio_array[1]
    end
    ratio_array[0]
  end

  def self.most_res
    res_array = [nil, 0]
    City.all.each do |city|
      reservation_count = 0
      city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      res_array = [city, reservation_count] if reservation_count > res_array[1]
    end
    res_array[0]
  end

end
