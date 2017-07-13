class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guests = []

    reservations.each do |r|
      guests << r.guest
    end

    guests
  end

  def hosts
    hosts = []

    trips.each do |t|
      hosts << t.listing.host
    end

    hosts
  end

  def host_reviews
    host_reviews = []

    listings.each do |l|
      l.reviews.each do |r|
        host_reviews << r
      end
    end

    host_reviews
  end
end
