class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations

  #as a guest, knows about the hosts its had (FAILED - 1)
  has_many :hosts, through: :reservations, source: "guest_id"
  #as a host, knows about its reviews from guests (FAILED - 2)
  has_many :host_reviews, through: :guests, source: "reviews"
end
