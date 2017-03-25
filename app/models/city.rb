require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods



  def city_openings(start_date, end_date)

   
      begin_date = DateTime.strptime(start_date, "%Y-%m-%d")
   
      date_end = DateTime.strptime(end_date, "%Y-%m-%d")
   

    search_range = (begin_date .. date_end)
    city_openings = []


    self.listings.each do |listing|
      checkins = []
      checkouts = []

      listing.reservations.each do |reservation|
        checkins << reservation.checkin
        checkouts << reservation.checkout
      end

      city_openings << listing if !search_range.overlaps?(checkins.sort.first .. checkouts.sort.last)

    end

    city_openings
  end

  def self.highest_ratio_res_to_listings


    city_ratio = 0.0
    highest_ratio_res_to_listings = nil

    City.all.each do |city|
      if city_ratio < city.reservations_count/city.listings.count.to_f
        city_ratio = city.reservations_count/city.listings.count.to_f
        highest_ratio_res_to_listings = city
      end
    end
    highest_ratio_res_to_listings
  end

  def self.most_res

    reservations = 0
    most_res = nil
    City.all.each do |city|
      if reservations < city.reservations_count
        reservations = city.reservations_count
        most_res = city
      end

    end
    most_res
  end





  def reservations_count
    city_reservations = 0
    self.listings.each do |listing|
      city_reservations += listing.reservations.count
    end
    city_reservations
  end


end

# City.highest_ratio_res_to_listings
