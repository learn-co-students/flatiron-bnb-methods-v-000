class City < ActiveRecord::Base
  extend Sortable::ClassMethods
  include Sortable::InstanceMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings


  def city_openings(checkin, checkout)
    listings.select do |listing|
      listing.reservations.none? do |reservation|
        (Date.parse(checkin) <= reservation.checkout) && (Date.parse(checkout) >= reservation.checkin)
        end
      end
    end


end
