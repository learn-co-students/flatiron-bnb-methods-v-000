class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
   self.reservations.collect do |reservation|
    reservation.guest
    end
  end

  def hosts
   self.trips.collect do |trip|
    trip.listing.host
    end
  end

  def host_reviews
    guests.collect do |guest|
      guest.reviews
    end.flatten
  end
  
end
