class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :listings, :foreign_key => 'guest_id'
  # has_many :hosts, through: :listings, :foreign_key => 'host_id', :class_name => 'User'

  def hosts
    self.trips.map {|trip| trip.listing.host}
  end

  def host_reviews
    self.guests.map {|guest| guest.reviews}.flatten
  end




end
