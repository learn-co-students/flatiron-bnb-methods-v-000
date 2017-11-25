class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(checkin, checkout)
    @listings = Listing.all
    @listings.each do |listing|
      listing.reservations.each do |reservation|
        checkin <= reservation.checkout.to_s && checkout >= reservation.checkin.to_s
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by {|city| city.n_of_reservations / city.listings.count}
  end

  def n_of_reservations
    @number_of_reservations = 0
    self.listings.each do |listing|
      @number_of_reservations += listing.reservations.count
    end
    @number_of_reservations
  end

  def self.most_res
    self.all.max_by {|city| city.n_of_reservations}
  end

end

