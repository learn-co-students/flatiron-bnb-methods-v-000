class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  extend Reservable::ClassMethods
  include Reservable::InstanceMethods

  def city_openings(checkin, checkout)
    listings.map do |l|
      l.reservations.none? do |r|
        (r.checkin < checkout.to_datetime && r.checkin > checkin.to_datetime) || (r.checkout > checkin.to_datetime  && r.checkout < checkout.to_datetime)
      end
    end
  end


end
