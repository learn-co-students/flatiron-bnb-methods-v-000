class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  
  def city_openings(checkin,checkout)
    @checkin = Date.parse(checkin)
    @checkout = Date.parse(checkout)
    @taken = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if @checkin.between?(reservation.checkin,reservation.checkout) || @checkout.between?(reservation.checkin,reservation.checkout)
          @taken << listing 
        end
      end
    end
    @open = []
    self.listings.each do |listing|
      if !@taken.include?(listing)
        @open << listing 
      end
    end
    @open
  end
  
  def self.most_res
    city_reservations = []
    self.all.each do |city|
      @city_count = 0
      city.listings.each do |listing|
        @city_count += listing.reservations.count
      end
      city_reservations << [city,@city_count]
    end
    city_reservations.sort! {|a,b| b[1] <=> a[1]}
    city_reservations[0][0]
  end
  
  def self.highest_ratio_res_to_listings
    city_reservations = []
    self.all.each do |city|
      @city_reservation_count = 0
      city.listings.each do |listing|
        @city_reservation_count += listing.reservations.count
      end
      @city_listing_count = city.listings.count
      @res_to_listing_ratio = @city_reservation_count/ @city_listing_count
      city_reservations << [city,@res_to_listing_ratio]
    end
    city_reservations.sort! {|a,b| b[1] <=> a[1]}
    city_reservations[0][0]
      
  end
  
end

