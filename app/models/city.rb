class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.all.select do |listing|
      listing.reservations.all do |reservation|
        reservation.openings(start_date, end_date)
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max {|a, b| a.ratio_res_to_listings <=> b.ratio_res_to_listings}
  end

  def self.most_res
    self.all.max {|a, b| a.number_reservations <=> b.number_reservations}
  end

  def ratio_res_to_listings
    self.listings.count > 0 ? self.number_reservations / self.listings.count : 0
  end

  def number_reservations
    self.listings.inject (0) {|reservations, res_per_listing| reservations + res_per_listing.reservations.count}
  end


end
