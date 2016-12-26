class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(s_date, e_date)

    input = Date.parse(e_date)..Date.parse(s_date)

    open_listings = []

    self.listings.each do |listing|
     if listing.reservations.none? do |reservation|
           range = reservation.checkin..reservation.checkout
           range.overlaps?(input)
        end
        open_listings << listing
      end
    end
    open_listings
  end


  def self.highest_ratio_res_to_listings
    city_with_most = ""
    index = 0
    City.all.each do |city|
      reservation_count = 0
      city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      if reservation_count > index
       index = reservation_count
       city_with_most = city
     end
    end
    city_with_most
   end




end
