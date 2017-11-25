class Neighborhood < ActiveRecord::Base
  include SharedMethods
  extend SharedMethods
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date1, date2)
    openings(date1, date2)
  end

  def self.highest_ratio_res_to_listings
    h_ratio_res_to_listings
  end

  def self.most_res
    neighborhood = select("neighborhoods.id, count(listing_id) AS listing_count").joins(:listings => :reservations).group(:city_id).order("listing_count DESC").limit(1)

    self.find(neighborhood.first.id)
  end


end
