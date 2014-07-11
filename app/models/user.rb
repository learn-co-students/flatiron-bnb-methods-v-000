class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  # crazy way to not make methods below
  # has_many :trip_listings, :through => :trips, :source => :listing
  # has_many :hosts, :through => :trip_listings, :foreign_key => :host_id
  # has_many :guests, :through => :reservations, :class_name => "User"

  # Returns all guests (objects) a host has had
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
    self.trips.collect do |trip|
      trip.listing.host
    end
  end

  # Returns all of a host's reviews from their guests
  def host_reviews
    guests.collect do |guest|
      guest.reviews
    end.flatten
  end
  
end
