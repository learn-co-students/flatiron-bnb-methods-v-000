class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(start, finish)
    start = Date.parse(start)
    finish = Date.parse(finish)

    listings.select do |listing|
    listing.reservations.none? do |reservation|
    !((start >= reservation.checkout) || (finish <= reservation.checkin))
    end
   end
  end
  def self.highest_ratio_res_to_listings
      highest = Neighborhood.all[0]
      self.all.each do |neighborhood|
        highest = neighborhood if (neighborhood.reservations.count/neighborhood.listings.count.to_f) > (highest.reservations.count/highest.listings.count.to_f)
      end
      highest
    end

  def self.most_res
    most = Neighborhood.all[0]
    self.all.each do |hood|
      most = hood if hood.reservations.count > most.reservations.count
    end
    most
  end

end
