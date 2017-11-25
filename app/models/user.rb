class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :host_reviews, through: :listings, source: :reviews
  has_many :guests, through: :reservations
  has_many :hosts, through: :trips, :foreign_key => 'guest_id', source: :listing, :class_name => "User"
end
