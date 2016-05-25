class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Reservable


  def city_openings(start_date, end_date)
    first_date = Date.parse(start_date)
    last_date = Date.parse(end_date)

    @available_listings = []

    listings.each do |listing|
      @available_listings << listing 
    end
    
    @available_listings.delete_if do |listing|
      listing.reservations.any? do |reservation|
        first_date.between?(reservation.checkin, reservation.checkout) || last_date.between?(reservation.checkin, reservation.checkout)
      end
    end
    @available_listings
  end

end

