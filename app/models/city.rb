class City < ActiveRecord::Base
  extend Sortable::ClassMethods
  include Sortable::InstanceMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings


  def city_openings(checkin, checkout)
    arr = []
    listings.each do |listing|
      listing.reservations.each do |reservation|
        if (Date.parse(checkin) <= reservation.checkout) && (Date.parse(checkout) >= reservation.checkin)
          arr << listing
        end
      end
    end
    arr
  end

end
