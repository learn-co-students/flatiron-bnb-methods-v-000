class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    self.listings.each do |listing|
      listing.reservations.collect do |reservation|
        if reservation.checkin == checkin && reservation.checkout == checkout
          listing
        end
      end
    end
  end

private

  def self.highest_ratio_res_to_listings
    hood_res_count = 0
    high_ratio = nil
    self.all.each do |hood|
      hood.listings.each do |listing|
        if hood_res_count < listing.reservations.count
          hood_res_count = listing.reservations.count
          high_ratio = hood
        end
      end
    end
    high_ratio
  end

    def self.most_res
      hood_res_count = 0
      most_res = nil
      self.all.each do |hood|
        hood.listings.each do |listing|
          if hood_res_count < listing.reservations.count
            hood_res_count = listing.reservations.count
            most_res = hood
          end
        end
      end
      most_res
    end

end
