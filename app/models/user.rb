class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :host_reviews, through: :reservations
  has_many :guests, through: :listings
  has_many :hosts, through: :trips
 
  # def hosts
  # 	trips.collect { |t| User.find(t.listing.host_id) }
  # end

  
end
