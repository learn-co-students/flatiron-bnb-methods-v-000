class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, :foreign_key => 'host_id', through: :listings
  has_many :hosts, :foreign_key => 'guest_id', through: :listings
  # has_many :guests
  
end
