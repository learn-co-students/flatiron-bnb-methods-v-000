class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  #user as host
  has_many :guests, through: :reservations, :class_name => "User"
  has_many :host_reviews, through: :guests, source: :reviews

  #user as guest
  has_many :trip_listings, through: :trips, source: :listings
  has_many :hosts, :class_name => "User", through: :trips, :source => "listing", :foreign_key => "host_id"
  
end
