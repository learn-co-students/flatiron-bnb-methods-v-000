class User < ActiveRecord::Base

  #HOSTS
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, through: :listings
  has_many :guests, through: :reservations
  has_many :host_reviews, through: :listings, :source => "reviews"

  #GUESTS
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :hosts, through: :trips

end
