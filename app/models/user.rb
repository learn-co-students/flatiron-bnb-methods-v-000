class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  # has_many :guests, :foreign_key => 'guest_id', through: :listings
  # has_many :hosts, :foreign_key => 'host_id', through: :trips

  def guests
    guests = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        guests << reservation.guest
      end
    end
    guests.uniq
  end

  def hosts
    hosts = []
    self.trips.each do |trip|
      hosts << trip.listing.host
    end
    hosts.uniq
  end

  def host_reviews
    host_reviews = []
    self.guests.each do |guest|
      guest.reviews.each do |review|
        host_reviews << review if review.reservation.listing.host == self
      end
    end
    host_reviews
  end

end
