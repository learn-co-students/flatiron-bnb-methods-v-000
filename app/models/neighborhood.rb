class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  # doing the same thing as city_openings, but formatted slightly differently.
  def neighborhood_openings(checkinstring, checkoutstring)
    open_listing = []

    listings_not_available(checkinstring, checkoutstring)

    self.listings.each do |listing|
      open_listing << listing if !@all_neighborhood_listings_in_date_range.include?(listing)
    end

  end

  ### repeat of same method in city.rb
  def listings_not_available(checkin_string, checkout_string)
    checkin_date = Date.parse(checkin_string)
    checkout_date = Date.parse(checkout_string)
    all_reservations = []
    @all_neighborhood_listings_in_date_range = []
    
    # 1) find all reservations
    Reservation.all.each do |reservation|
      all_reservations << reservation
    end
    # 2) keep only the reservations from that neighborhood
    all_reservations.keep_if{ |reservation| reservation.listing.neighborhood.id == self.id}
    # 3) keep only the reservations from that neighborhood from a date range
    all_reservations.keep_if{ |reservation| !(reservation.checkin > checkout_date) && !(reservation.checkout < checkin_date) }
    # 4) keeping the listings that are booked in a date range
    all_reservations.each do |reservation|
      @all_neighborhood_listings_in_date_range << reservation.listing
    end
  end

  def self.most_res
    @reservations_per_neighborhood = {}

    Neighborhood.all.each do |neighborhood|
      @reservations_per_neighborhood[neighborhood.id] = neighborhood.reservations.size
    end

    Neighborhood.find(@reservations_per_neighborhood.sort_by{|key, value| value }.last[0])
  end

  def self.highest_ratio_res_to_listings
    @neighborhood_ratio_reservations_to_listings = {}
    all_neighborhoods = []

    Neighborhood.all.each do |neighborhood|
      all_neighborhoods << neighborhood
    end

    all_neighborhoods.each do |neighborhood|
      @neighborhood_ratio_reservations_to_listings[neighborhood.id] = neighborhood.reservations.size.fdiv(neighborhood.listings.size) if neighborhood.reservations.size > 0 && neighborhood.listings.size > 0
    end

    Neighborhood.find(@neighborhood_ratio_reservations_to_listings.sort_by{ |key, value| value }.last[0])

  end

end
