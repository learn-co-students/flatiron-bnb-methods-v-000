class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(res_start, res_end)
    listings.each do |listing|
      listing.reservations.collect do |reservation|
        if reservation.checkin == res_start && reservation.checkout == res_end
          listing
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    res_count = 0
    highest_res_count_neighborhood = nil
    self.all.each do |neighborhood|
      neighborhood.listings.each do |listing|
        if res_count < listing.reservations.count
          res_count = listing.reservations.count
          highest_res_count_neighborhood = neighborhood
        end
      end
    end
    highest_res_count_neighborhood
  end
  def self.most_res
    self.all.max_by do |neighborhood|
      number_of_reservations = 0
      neighborhood.listings.each do |listing|
        number_of_reservations += listing.reservations.size
      end
      number_of_reservations
    end
  end

end
