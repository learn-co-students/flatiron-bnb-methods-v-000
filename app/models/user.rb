class User < ActiveRecord::Base
  #Guest
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :hosts, :through => :listings, :foreign_key => 'guest_id', :class_name => "User"
  # has_many :hosts, :foreign_key => 'host_id', :class_name => "User"
  #Host
  # has_many :guests, :through => :reservations
  has_many :host_reviews, :through => :reservations, :foreign_key => 'host_id', :class_name => "Review"
  has_many :listings, :foreign_key => 'host_id'
end
