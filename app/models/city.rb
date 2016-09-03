class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(desired_checkin, desired_checkout)
    problem_listings = []
    # cycle through all the listings of self
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation_conflict?(reservation, desired_checkin, desired_checkout)
          problem_listings << listing unless problem_listings.include?(listing)
        end
      end
    end
    openings = self.listings.all - problem_listings
  end

  def reservation_conflict?(reservation, ckin, ckout)
    # return true if there is a conflict
    desired_checkin = ckin.to_date
    desired_checkout = ckout.to_date
    if reservation.checkout > desired_checkin && reservation.checkout < desired_checkout
      return true
    elsif reservation.checkin > desired_checkin && reservation.checkin < desired_checkin
      return true
    end
    return false
  end
end
