class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # Searches through the city's listings for open listings. 
  # Accepts a starting date and ending date.
  # A listing is considered open if it has no reservations that overlap those dates.
  def city_openings(start_date, end_date)
    start_date, end_date = Date.parse(start_date), Date.parse(end_date)
    city_listings = self.listings
    open_listings = []

    # For each listing:
    #   Find all the non blocking reservations where checkin is after the end date OR checkout is before the start date.
    #   Compare the count of the listing's non blocking reservations with all its total reservations.
    #   If the counts match, that means the listing is available during the specific time period.
    #   Push those listings into the open_listings array for return
    city_listings.each do |listing|
      blocking_reservations =  listing.reservations.where("checkout > ? AND checkin < ?", start_date, end_date)
      open_listings << listing if blocking_reservations.count == 0
    end

    open_listings
  end

  # Searches through all cities and calculates their reservations to listings ratio.
  # Returns the city which has the highest ratio.
  def self.highest_ratio_res_to_listings
    cities = City.all
    highest_ratio = 0.0
    city_with_highest_ratio = nil

    # Loop through each city to find the highest reservations to listings ratio. 
    cities.each do |city|
      listings_count = city.listings.count
      res_count = city.listings.joins(:reservations).count

      city_ratio = res_count.to_f / listings_count

      # Reassign highest_ratio and city_with_highest_ratio
      if city_ratio > highest_ratio
        highest_ratio = city_ratio
        city_with_highest_ratio = city
      end
    end

    city_with_highest_ratio
  end

  # Searches through all cities and finds the count of all reservations in the city's listings.
  # Returns the city with the highest reservations count.
  def self.most_res
    cities = City.all
    highest_res_count = 0
    city_with_most_res = nil

    # Loop through each city and find city with the highest number of reservations.
    cities.each do |city|
      city_res_count = city.listings.joins(:reservations).count

      # Reassign highest_res_count and city_with_most_res
      if city_res_count > highest_res_count
        highest_res_count = city_res_count
        city_with_most_res = city
      end 
    end

    city_with_most_res
  end

end

