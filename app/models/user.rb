class User < ActiveRecord::Base
## For Hosts
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
## For Guests
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
## For Hosts
  has_many :guests, through: :reservations, foreign_key: 'guest_id'
## For Guests
  has_many :guest_listings, through: :trips, source: :listing
  has_many :hosts, through: :guest_listings, foreign_key: 'host_id'
## For Hosts
  has_many :host_reviews, through: :listings, source: :reviews

end
