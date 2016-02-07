class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id' # as a host
  has_many :reservations, :through => :listings # as a host
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation" # as a guest
  has_many :reviews, :foreign_key => 'guest_id' # as a guest

  has_many :guests, :through => :reservations, :class_name => "User" #as a host

  has_many :trip_listings, :through => :trips, :source => :listing # as a guest
  has_many :hosts, :through => :trip_listings, :foreign_key => 'host_id'

  has_many :host_reviews, :through => :guests, :source => :reviews # as a host
  
end
