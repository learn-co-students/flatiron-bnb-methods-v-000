class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => 'Reservation'
  has_many :reviews, :foreign_key => 'guest_id'

  has_many :trip_listings, :through => :trips, :source => :listing
  #SELECT * FROM listings INNER JOIN reservations ON listings.id = reservations.listing_id WHERE reservations.guest_id = 4
  has_many :guests, :through => :reservations
  has_many :hosts, :through => :trip_listings
  #SELECT * FROM users INNER JOIN listings ON users.id = listings.host_id INNER JOIN reservations ON listings.id = reservations.listing_id WHERE reservations.guest_id = 4
  has_many :host_reviews, :through => :guests, :source => :reviews
  #SELECT * FROM reviews INNER JOIN users ON reviews.guest_id = users.id INNER JOIN reservations ON users.id = reservations.guest_id INNER JOIN listings ON reservations.listing_id = listings.id WHERE listings.host_id = 1
end
