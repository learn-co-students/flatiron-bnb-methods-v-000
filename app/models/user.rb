class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :trip_listings, :through => :trips, :source => :listing
  has_many :hosts, :through => :trip_listings, :foreign_key => :host_id
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :guests, :source => :reviews
  
  def hosts
    self.trips.map {|trip| trip.listing.host}
  end

  def host_reviews
    Review.all.select do |review|
      review.reservation.listing.host == self
    end
  end
end
