class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def hosts
    hosts = []
    trips.all.each do |trip|
      hosts << trip.listing.host
    end
    hosts
  end

  def guests
    guests = []
    listings.all.each do |listing|
      listing.reservations.each do |reservation|
        guests << reservation.guest
      end
    end
    guests
  end

  def host_reviews
    reviews = []
    listings.all.each do |listing|
      listing.reservations.each do |reservation|
        reviews << reservation.review
      end
    end
    reviews
  end

end
