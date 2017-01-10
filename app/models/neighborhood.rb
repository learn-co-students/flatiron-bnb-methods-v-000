class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(start_date, end_date)
    openings = []
    Listing.all.each do |list|
      if list.available?(start_date, end_date)
        openings << list
      end
    end
    openings
  end

  def self.highest_ratio_res_to_listings
    all.max_by do |neighborhood|
      reservations = neighborhood.reservations.count
      listings = neighborhood.listings.count
      if listings == 0
        0
      else
        reservations / listings
      end
    end
  end

  def self.most_res
    all.max_by do |neighborhood|
      neighborhood.reservations.count
    end
  end

end
