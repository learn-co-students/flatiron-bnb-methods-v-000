class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, :class_name => "User", :through => :listings
  has_many :host_reviews, :class_name => "Review", through: :listings, :source => :reviews

  has_many :my_reservations, :class_name => "Reservation", :foreign_key => "guest_id"
  has_many :my_listings, :class_name => "Listing", through: :my_reservations, :source => :listing
  has_many :hosts, :class_name => "User", through: :my_listings
end
