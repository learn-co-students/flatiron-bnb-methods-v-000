class Neighborhood < ActiveRecord::Base
  belongs_to :city

  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(begin_date, end_date)
    self.listings(created_at: begin_date..end_date)
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    highest_ratio_neighborhood = nil

    self.all.each do |neighborhood|
      current_ratio = (neighborhood.reservations.all.count.to_f / neighborhood.listings.all.count.to_f)
      if highest_ratio < current_ratio
        highest_ratio = current_ratio
        highest_ratio_neighborhood = neighborhood
      end
    end
    highest_ratio_neighborhood
  end

  def self.most_res
    most_reservations_neighborhood = nil
    reservations_count = 0

    self.all.each do |neighborhood|
      if neighborhood.reservations.count > reservations_count
        most_reservations_neighborhood = neighborhood
        reservations_count = neighborhood.reservations.count
      end      
    end
    most_reservations_neighborhood
  end

end
