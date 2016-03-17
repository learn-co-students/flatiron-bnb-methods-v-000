class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start, finish)
    all_listings = self.listings
    available = all_listings.select { |listing| listing.available?(start, finish) }
  end

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max_by do |neighborhood|
      neighborhood.res_to_listing_ratio
    end
  end

  def res_to_listing_ratio
    if self.listings.count != 0
      reservations.count / self.listings.count
    else
      return 0
    end
  end

  def self.most_res
    Neighborhood.all.max_by do |neighborhood|
      neighborhood.reservations.count
    end
  end

end