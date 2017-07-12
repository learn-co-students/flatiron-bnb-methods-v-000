class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    self.listings.select do |listing|
      listing.reservations.all? do |reservation|
        ((Date.parse(checkin)) >= reservation.checkout) || ((Date.parse(checkout)) <= reservation.checkin)
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by {|neighborhood| neighborhood.listings.count.zero? ? 0 : neighborhood.reservations.count / neighborhood.listings.count}
  end

  def self.most_res
    self.all.max {|a, b| a.reservations.count <=> b.reservations.count }
  end
end
