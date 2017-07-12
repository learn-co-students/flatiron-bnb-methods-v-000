class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, :class_name => "User", through: :reservations
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :hosts, :class_name => "User", through: :trips, :source => :listing
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :host_reviews, through: :listings, :source => :reviews
end
