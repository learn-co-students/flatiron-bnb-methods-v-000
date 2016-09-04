class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  has_many :guests, :class_name => "User", :through => :reservations

  # has_many :hosts, :class_name => "User", :through => :reservations, :source => :listings
end
