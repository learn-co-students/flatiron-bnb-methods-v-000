class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    start_date = Date.parse start_date
    end_date = Date.parse end_date
    @city_listings = []
    self.city.listings.each {|l| @city_listings << l}
    r = Reservation.where("checkin <= ? and checkout >= ?", end_date, start_date)
    @city_listings.keep_if {|listing| !listing.reservations.include?(r)}
  end

  def self.most_res
    Neighborhood.all.max_by {|neighborhood| neighborhood.total_reservations}
  end

  def self.highest_ratio_res_to_listings
    @all_neighborhoods = []
    Neighborhood.all.each do |neighborhood|
      if neighborhood.total_reservations != 0 && neighborhood.listings.count != 0
        @all_neighborhoods << neighborhood
      end
    end
    @all_neighborhoods.max_by do |neighborhood|
      neighborhood.total_reservations/neighborhood.listings.count
    end
  end

  def total_reservations
    @total = 0
    self.listings.each do |listing|
      @total += listing.reservations.count
    end
    @total
  end

end
