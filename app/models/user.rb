class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :host_reviews, :through => :reservations, :source => :review
  has_many :guests, :foreign_key => 'host_id', :class_name => "User", :through => :listings
  # has_many :trip_listings, :through => :reservations, :source => :trip
  # has_many :host_listings, :through => :trip_listings, :source => :listing
  # has_many :hosts, :foreign_key => 'guest_id', :class_name => "User", :through => :host_listings


  # has_many :listings, :foreign_key => 'guest_id', :class_name => "User", :through => :trips
  # has_many :listings, :foreign_key => 'guest_id', :class_name => "User", :through => :reservations
  # has_many :friendships
  # has_many :hosts, :through => :friendships
end
