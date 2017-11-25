class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, :through => :reservations

  #As a guest setup
  has_many :trip_listings, through: :trips, :source => :listing
  #Has many hosts
  has_many :hosts, through: :trip_listings

  #As a host setup
  has_many :host_reviews, through: :reservations, :source => :review
end
