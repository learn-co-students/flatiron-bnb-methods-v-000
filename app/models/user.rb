class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings

  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"

  # Returns all guests (objects) a host has had
  # This might not be the best way to do this, if our database gets larger
  def guests
    host_guests = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        host_guests << reservation.guest
      end
    end
    return host_guests
  end

  # Returns all hosts (objects) a guest has had
  def hosts
    self.reservations.collect do |reservation|
      reservation.listing.host
    end
  end

  # Returns all of a host's reviews from their guests
  def host_reviews
    guests.collect do |guest|
      guest.reviews
    end.flatten
  end
  
end
