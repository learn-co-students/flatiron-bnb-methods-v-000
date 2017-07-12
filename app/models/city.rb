class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  extend Reservable::ClassMethods
  include Reservable::InstanceMethods




  def city_openings(checkin, checkout)
     openings = Listing.available(checkin, checkout) & self.listings
  end


    #list = []
    #listings.each do |l|
    #  if l.reservations.none? do |r|
    #    (r.checkin < checkout.to_datetime && r.checkin > checkin.to_datetime) || (r.checkout > checkin.to_datetime  && r.checkout < checkout.to_datetime)
    #  list << l
    #  end
    #end
    #list.flatten



end
