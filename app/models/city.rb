class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  include FindAvailableListings::InstanceMethods
  extend FindAvailableListings::ClassMethods

  def city_openings(date1, date2)
    Listing.all.each do |listing|
      listing_reservations(listing, date1, date2)
    end
  end

private

  def self.self_name_of_reservation(x)
    reservation_by_self = []
    Reservation.all.each do |r|
      if r.listing.neighborhood.city.name == x.name
        reservation_by_self << r
      end
    end
    reservation_by_self
  end

end
