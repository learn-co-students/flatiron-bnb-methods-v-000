class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  # User associations as a host, knows about the guests its had
  # User associations as a host, knows about its reviews from guests
  has_many :guests, :through => :reservations
  has_many :host_reviews, :through => :guests, :source => :reviews

  # User associations as a guest, knows about the hosts its had
  has_many :trip_listings, :through => :trips, :source => :listing
  has_many :hosts, :through => :trip_listings
end
