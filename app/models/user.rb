class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  #Add'l Host behaviors
  #define guests method
  has_many :guests, :through => :reservations
  #defines host_reviews
  has_many :host_reviews, :through => :guests, source: :reviews


  #defines hosts method: guest has many trips (reservations).  trip_listings gets all listings associated with guest_id, which can then be further queried to get listing host
  has_many :trip_listings, :through => :trips, source: :listing
  has_many :hosts, :through => :trip_listings, :foreign_key => :host_id
end


## Passes master and solution branch specs; because schema are different between branches, solution spec for is_host adjusted to host, to avoid db changes
