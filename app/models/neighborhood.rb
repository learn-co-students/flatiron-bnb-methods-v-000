class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        #reservation.where(checkin: start_date..end_date).empty? && reservation.where(checkout: start_date..end_date).empty?
        reservation.checkin <= end_date.to_date && reservation.checkout >= start_date.to_date
      end
    end
  end

  def self.highest_ratio_res_to_listings
    @neighborhoods = []

    self.all.each do |hood|
      if hood.listings.count > 0 && hood.reservations.count > 0
        @neighborhoods << hood
      end
    end

    @neighborhoods.max_by {|hood| hood.reservations.count / hood.listings.count}
  end

  def self.most_res
    self.all.max_by {|hood| hood.reservations.count}
  end
end
