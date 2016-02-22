class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(starting, ending)
    starting_date = Date.parse(starting)
    ending_date = Date.parse(ending)
    available_listings = []

    listings.each do |listing|
      unavailable = listing.reservations.any? do |reservation|
        starting_date.between?(reservation.checkin, reservation.checkout) || ending_date.between?(reservation.checkin, reservation.checkout)
      end
      unless unavailable
        available_listings << listing
      end
    end
    return available_listings
  end

  def self.highest_ratio_res_to_listings
    most_popular_neighborhood = "None exist."
    highest_ratio = 0.00
    
    self.all.each do |neighborhood|
      numerator = neighborhood.reservations.count
      denominator = neighborhood.listings.count
      if numerator == 0 || denominator == 0
        "Ratio not available."
      else
        neighborhood_ratio = numerator / denominator
        if neighborhood_ratio > highest_ratio
          highest_ratio = neighborhood_ratio
          most_popular_neighborhood = neighborhood
        end
      end
    end
    most_popular_neighborhood
  end

  def self.most_res
    reservations = 0
    most_reservations = "None exist."
    self.all.each do |neighborhood|
      rsvp = neighborhood.reservations.count
      if rsvp > reservations
        reservations = rsvp
        most_reservations = neighborhood
      end
    end
    most_reservations
  end
end
