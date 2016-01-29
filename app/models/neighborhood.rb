class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date_start, date_end)
    parsed_start = Date.parse(date_start)
    parsed_end = Date.parse(date_end)
    openings = []
    listings.each do |listing|
      blocked = listing.reservations.any? do |reservation|
        parsed_start.between?(reservation.checkin, reservation.checkout) || parsed_end.between?(reservation.checkin, reservation.checkout)
      end
      unless blocked
        openings << listing
      end
    end
    return openings
  end

  def self.highest_ratio_res_to_listings
    highest_neighborhood = "none"
    highest_ratio = 0.00
    self.all.each do |neighborhood|
      denominator = neighborhood.listings.count
      numerator = neighborhood.reservations.count
      if denominator == 0 || numerator == 0
        next
      else
        popularity_ratio = numerator / denominator
        if popularity_ratio > highest_ratio
          highest_ratio = popularity_ratio
          highest_neighborhood = neighborhood
        end
      end
    end
    highest_neighborhood
  end

  def self.most_res
    highest_neighborhood = "none"
    high_num = 0
    self.all.each do |neighborhood|
      neighborhood_size = neighborhood.reservations.size #this way only queries once
      if neighborhood_size > high_num
        highest_neighborhood = neighborhood
        high_num = neighborhood_size
      end
    end
    highest_neighborhood
  end

end
