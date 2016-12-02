class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    available_listings = []
    self.listings.each do |listing|
      conflicts = []
      listing.reservations.each do |reservation|
        conflicts = []
        if reservation.checkin <= start_date.to_date && reservation.checkout > start_date.to_date
          conflicts << reservation
        end
      end
      if !conflicts.any?
        available_listings << listing
      end
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
    highest_city = ""
    highest_ratio = ""
    self.all.each do |city|
      city.listings.each do |listing|
        if listing.reservations.count > highest_ratio.to_i
          highest_ratio = listing.reservations.count
          highest_city = city
        end

      end
    end
    highest_city
  end

  def self.most_res
    top_city = ""
    top_res_count = ""
    self.all.each do |city|
      city_reservations = []
      city.listings.each do |listing|
        listing.reservations.each do |reservation|
          city_reservations << reservation
        end
      end
      if city_reservations.count > top_res_count.to_i 
        top_res_count = city_reservations.count 
        top_city = city 
      end
    end
    top_city
  end

end

