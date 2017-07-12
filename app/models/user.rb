class User < ActiveRecord::Base
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :listings, :foreign_key => 'host_id', :source => "reviews"
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings

  has_many :guest_listings, :through => :trips, :source => "listing"
  has_many :hosts, :through => :guest_listings

end


