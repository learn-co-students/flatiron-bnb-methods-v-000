class City < ActiveRecord::Base

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  # return all of the open listings in a city within specific dates
  def city_openings(start, ending)
    open_listing = []
    self.listings.each do |listing|
      if listing.available?(start, ending)
        open_listing << listing
      end
    end
    open_listing
  end

  # Returns the city that has the highest amount of reservations per listing
  def self.highest_ratio_res_to_listings
    highest_city = nil # tracks the city with the highest ratio
    highest_ratio = 0

    # For each city, check each listing and add the number of reservations.
    self.all.each do |city|
      reservation_count = 0
      res_to_listing_ratio = 0

      city.listings.each do |listing|
        reservation_count = reservation_count + listing.reservations.count
      end

      unless city.listings.empty?
        # Using the total number of reservations for a city, find the ratio of reservations to listings
        res_to_listing_ratio = reservation_count / city.listings.count

        # If a city has a higher ratio than the current highest, it becomes the highest city.
        if res_to_listing_ratio > highest_ratio
          highest_city = city
          highest_ratio = res_to_listing_ratio
        end
      end
    end

    highest_city
  end

  # Returns the city with the most number of reservations.
  def self.most_res
    highest_city = nil # Tracks the city with the highest amount of reservations.
    highest_res_count = 0

    # For each city, check each listing and add the number of reservations to the total.
    self.all.each do |city|
      res_count = 0

      city.listings.each do |listing|
        res_count = res_count + listing.reservations.count
      end

      # if a cities total num of reservations is higher than the current highest city,
      # it becomes the new highest city.
      if res_count > highest_res_count
        highest_res_count = res_count
        highest_city = city
      end
    end

    highest_city
  end

end

