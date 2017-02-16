class User < ActiveRecord::Base
  #Guest
  has_many :reservations, :through => :listings, :foreign_key => 'guest_id'
  # has_many :reservations, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  # has_many :hosts, :through => :listings, :foreign_key => 'guest_id', :class_name => "User"
  # has_many :hosts, :foreign_key => 'host_id', :class_name => "User"
  # has_many :hosts, :through => :listings, :class_name => "User"
  # has_many :hosts, :through => :listings, :source => "reservations"
  #Host
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :listings, :foreign_key => 'host_id', :source => "reviews"
  has_many :listings, :foreign_key => 'host_id'
end


