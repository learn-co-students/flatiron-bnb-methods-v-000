class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.most_res
    top_neighborhood = self.all[0]
    self.all.each do |neighborhood|
      if neighborhood.reservations.count > top_neighborhood.reservations.count
        top_neighborhood = neighborhood
      end
    end
    top_neighborhood
  end

  def self.highest_ratio_res_to_listings
    top_neighborhood = self.all[0]
    self.all.each do |neighborhood|
      if (neighborhood.reservations.count.to_f/neighborhood.listings.count.to_f) > (top_neighborhood.reservations.count.to_f/top_neighborhood.listings.count.to_f)
        top_neighborhood = neighborhood
      end
    end
    top_neighborhood
  end

  def neighborhood_openings(start_date, end_date)
    available = self.listings.select do |listing|
      listing.reservations.none? do |reservation|
        !((end_date.to_datetime <= reservation.checkin) || (start_date.to_datetime >= reservation.checkout))
      end
    end
    available
  end

end
