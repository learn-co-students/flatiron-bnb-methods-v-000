class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.listings.map{|listing|listing.guests}.flatten
  end

  def hosts
    self.trips.map{|trip| trip.listing.host}
  end

  def host_reviews
    self.listings.map{|listing| listing.reviews}.flatten
  end
  
end
