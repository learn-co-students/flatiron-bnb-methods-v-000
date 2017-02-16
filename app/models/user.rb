class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :host_reviews, :through => :reservations, :source => :review
  has_many :guests, :foreign_key => 'host_id', :class_name => "User", :through => :listings
  has_many :guest_listings, :through => :trips, :source => :listing
  has_many :hosts, :through  => :guest_listings



  # has_many :host_listings, :through => :trip_listings, :source => :listing
  # has_many :hosts, :foreign_key => 'guest_id', :class_name => "User", :through => :host_listing


  # has_many :listings, :foreign_key => 'guest_id', :class_name => "User", :through => :trips
  # has_many :listings, :foreign_key => 'guest_id', :class_name => "User", :through => :reservations
  # has_many :friendships
  # has_many :hosts, :through => :friendships
end
