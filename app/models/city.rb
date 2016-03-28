class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(beginning_date, end_date)
    # a listing is available if: it returns NO reservations in the given date range.
    available_listings = []
    listings.each do |listing|
      if listing.reservations.where("checkin >= ? AND checkout <= ?", beginning_date, end_date).empty?
        available_listings << listing
      end
    end
    available_listings
  end


  def self.highest_ratio_res_to_listings
    # for each listing, count the number of reservations, count number of listings, save as a ratio for the city 
    # then compare cities' ratios, and return the city with smallest number
    cities_with_scores = {}

    self.all.each do |city|
      number_of_listings = city.listings.count
      reservation_counts = city.listings.map { |listing| listing.reservations.count } # array of res counts
      sum_of_reservations = 0
      reservation_counts.each { |count| sum_of_reservations = count + sum_of_reservations } # update sum_of_reservations
      ratio_score = number_of_listings.to_f / sum_of_reservations.to_f 
      cities_with_scores[city] = ratio_score
    end

    cities_with_scores.min_by { |city, score| score }.first # return the key (city) of the lowest score
  end

  def self.most_res
    cities_with_reservation_counts = {}
    
    self.all.each do |city|
      reservation_counts = city.listings.map { |listing| listing.reservations.count }
      sum_of_reservations = 0
      reservation_counts.each { |count| sum_of_reservations = count + sum_of_reservations }
      cities_with_reservation_counts[city] = sum_of_reservations
    end

    cities_with_reservation_counts.max_by { |city, reservations| reservations }.first
  end

end

