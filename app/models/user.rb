class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id' #has listings as host
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation" #has trips as guest
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations, class_name: :User #as a host, knows about guests it's had
  has_many :trip_listings, through: :trips, source: :listing
  has_many :hosts, through: :trip_listings, :foreign_key => 'host_id'
  has_many :host_reviews, through: :listings, source: :reviews
end
