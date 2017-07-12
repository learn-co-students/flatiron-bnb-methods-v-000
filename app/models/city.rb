class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
  	res_arr = self.listings.collect do |listing|
  		listing.reservations.where("checkin <= ?", end_date)
  		listing.reservations.where("checkout >= ?", start_date)
  	end

  	list_arr = res_arr.flatten.collect do |res|
  		res.listing
  	end
  	
  	self.listings - list_arr.uniq
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    highest_city = nil

    self.all.each do |city|
      res_num = 0
      current_ratio = 0.0
      listing_num = city.listings.length

      city.listings.each do |listing|
        res_num += listing.reservations.length
      end

      current_ratio = res_num.to_f / listing_num.to_f unless listing_num == 0 || res_num == 0

      if current_ratio > highest_ratio
        highest_ratio = current_ratio
        highest_city = city
      end
    end

    highest_city
  end

  def self.most_res
    highest_res = 0
    highest_city = nil
    self.all.each do |city|
      res_num = 0

      city.listings.each do |listing|
        res_num += listing.reservations.length
      end

      if res_num >= highest_res
        highest_res = res_num
        highest_city = city
      end
    end

    highest_city
  end
end

