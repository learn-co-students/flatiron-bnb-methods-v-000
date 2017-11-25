class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    @listings = Listing.all
    @listings.each do |listing|
      listing.reservations.each do |reservation|
        checkin <= reservation.checkout.to_s && checkout >= reservation.checkin.to_s
      end
    end
  end

  def ratio
    if listings.count > 0  
      reservations.size.to_f / listings.size.to_f
    else
      0
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max do |a, b|
      a.ratio <=> b.ratio
    end
  end

  def self.most_res
    self.all.max do |a, b|
      a.reservations.size <=> b.reservations.size
    end
  end
end
