class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  
  def neighborhood_openings(checkin,checkout)
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
    neighborhood_reservations = []
    self.all.each do |neighborhood|
      @neighborhood_count = 0
      neighborhood.listings.each do |listing|
        @neighborhood_count += listing.reservations.count
      end
      neighborhood_reservations << [neighborhood,@neighborhood_count]
    end
    neighborhood_reservations.sort! {|a,b| b[1] <=> a[1]}
    neighborhood_reservations[0][0]
  end
  
  def self.highest_ratio_res_to_listings
    neighborhood_reservations = []
    self.all.each do |neighborhood|
      @neighborhood_reservation_count = 0
      neighborhood.listings.each do |listing|
        @neighborhood_reservation_count += listing.reservations.count
      end
      @neighborhood_listing_count = neighborhood.listings.count
      if @neighborhood_listing_count == 0 || @neighborhood_reservation_count == 0
        @res_to_listing_ratio = 0
      else
        @res_to_listing_ratio = @neighborhood_reservation_count/ @neighborhood_listing_count
      end
      neighborhood_reservations << [neighborhood,@res_to_listing_ratio]
    end
    neighborhood_reservations.sort! {|a,b| b[1] <=> a[1]}
    neighborhood_reservations[0][0]
  end
  
  
end
