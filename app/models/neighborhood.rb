class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    results = []
    listings.each do |listing|
      listing.reservations.each do |reservation|
        reservation.checkin.to_s >= start_date && reservation.checkout.to_s <= end_date
      end
    end
  end

  def self.highest_ratio_res_to_listings
    highest_ratio_neighborhood = 0
    highest_ratio = 0

    self.all.each do |neighborhood|
      current_ratio = (neighborhood.reservations.count.to_f / neighborhood.listings.count.to_f)
      if current_ratio > highest_ratio
        highest_ratio = current_ratio
        highest_ratio_neighborhood = neighborhood
      end
    end

    highest_ratio_neighborhood
  end

  def self.most_res
    most_res_neighborhood = nil
    highest_neighborhood_count = 0
    self.all.each do |neighborhood|
      if neighborhood.reservations.count > highest_neighborhood_count
        most_res_neighborhood = neighborhood
        highest_neighborhood_count = neighborhood.reservations.count
      end
    end
    most_res_neighborhood
  end

end
