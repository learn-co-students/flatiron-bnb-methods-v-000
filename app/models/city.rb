class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_from, date_to)
    output = []
    res_from = Date.parse(date_from)
    res_to = Date.parse(date_to)
    listings.each do |listing|
      if listing.reservations.select{|reservation| reservation.checkin.between?(res_from, res_to) || reservation.checkout.between?(res_from, res_to)} == []
        output << listing
      end 
    end
  end

  def self.highest_ratio_res_to_listings
    city_id = 0
    max_ratio = 0

    self.all.each do |city|
      listings_count = city.listings.count
      reservations_count = city.listings.collect{|listing| listing.reservations.count}.inject(0) { |sum, n| sum + n }
      if listings_count > 0
        ratio = reservations_count / listings_count
      else
        ratio = 0
      end
      if ratio > max_ratio
        max_ratio = ratio
        city_id = city.id
      end
    end
    self.find(city_id)
  end

  def self.most_res
    city_id = 0
    max_reservations_count = 0

    self.all.each do |city|
      reservations_count = city.listings.collect{|listing| listing.reservations.count}.inject(0) { |sum, n| sum + n }
      if reservations_count > max_reservations_count
        max_reservations_count = reservations_count
        city_id = city.id
      end
    end
    self.find(city_id)
  end

end