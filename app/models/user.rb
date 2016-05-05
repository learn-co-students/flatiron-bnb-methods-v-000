class User < ActiveRecord::Base

  # as user
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :stays, :through => :trips, :source => :listing
  has_many :hosts, :through => :stays
  has_many :reviews, :foreign_key => 'guest_id'

  # as host
  has_many :listings, :foreign_key => 'host_id'
  has_many :guests, :through => :listings
  has_many :reservations, :through => :listings
  has_many :host_reviews, :through => :reservations, :source => :review

end
