class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :neighborhoods

  def city_openings(checkin, checkout)
      self.listings.find_all do |listing|
      listing.reservations.all? do |res|
         (checkin.to_datetime >= res.checkout) || (checkout.to_datetime <= res.checkin)
      end
    end
  end

  def res_to_listings_ratio
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    else
      0
    end
  end

  def self.highest_ratio_reservations_to_listings
    self.all.max {|a, b| a.res_to_listings_ratio <=> b.res_to_listings_ratio}
  end

  def self.most_reservations
    self.all.max {|a, b| a.reservations.count <=> b.reservations.count}
  end
end

## Passes solution branch.  Fails master branch specs for instance, class methods; failures traced back to Reservation model validation #is_available (validation passes both branches' specs)
