class User < ActiveRecord::Base
  #As host:
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, through: :reservations, foreign_key: 'host_id'
  has_many :host_reviews, through: :reservations, source: :review

  #As guest:
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :rentals, through: :trips, source: :listing
  has_many :hosts, through: :rentals, foreign_key: "host_id"

end
