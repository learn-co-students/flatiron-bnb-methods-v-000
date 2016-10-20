class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    available_reservations = []
    listings.each do |listing|
      available = listing.reservations.all? do |res|
        Date.parse(start_date) >= res.checkout || Date.parse(end_date) <= res.checkin
      end
      if available 
        available_reservations << listing
      end 
    end
    available_reservations
  end  

end
