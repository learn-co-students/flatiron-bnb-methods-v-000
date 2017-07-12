class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guests = self.listings.collect do |listing|
      listing.guests
    end
    guests.flatten
  end

  def guests
    guests = self.listings.collect do |listing|
      listing.guests
    end
    guests.flatten
  end

  def hosts
    hosts = self.trips.collect do |trip|
      trip.listing.host
    end
    hosts.flatten
  end

  def host_reviews
    reviews = self.reservations.collect do |reservation|
      reservation.review
    end
    reviews.flatten
  end

end
