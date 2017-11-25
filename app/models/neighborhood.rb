class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(check_in, check_out)
    check_in = Date.parse(check_in)
    check_out = Date.parse(check_out)
    available_neighborhood_listings = []
    listings.map do |listing|
      if listing.reservations.none? { |res|  res.checkin.between?(check_in, check_out) && res.checkout.between?(check_in, check_out) }
        available_neighborhood_listings << listing
      end
    end
    available_neighborhood_listings
  end

  def self.highest_ratio_res_to_listings
    neighborhood_with_highest_ratio = ''
    highest_ratio = 0

    self.all.map do |neighborhood|
      if neighborhood.listings.count == 0 || neighborhood.reservations.count == 0
        neighborhood_ratio = 0
      else
        neighborhood_ratio = neighborhood.reservations.count/neighborhood.listings.count.to_r
      end
      if neighborhood_ratio > highest_ratio
        neighborhood_with_highest_ratio = neighborhood
        highest_ratio = neighborhood_ratio
      end
    end
    neighborhood_with_highest_ratio
  end

  def self.most_res
    most_res_array = self.all.sort_by {|x| x.reservations.count}
    most_res_array.last
  end

end
