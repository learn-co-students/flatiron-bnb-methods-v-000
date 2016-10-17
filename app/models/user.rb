class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  # As a host, knows how many guests it has
  has_many :guests, :through => :reservations #:class_name => "User"
  # As a host, knows about its reviews from guests
  has_many :host_reviews, :through => :guests, :source => :reviews
 
  # WRONG! Don't want to override our other trips
  # has_many :trips, :through => :reservations, :source => :listings


  # we were missing this. I think we need it.... Might not need this line
  # has_many :reservations, :foreign_key => 'guest_id'
  # As a guest, knows about the hosts its had### this is close but not there
  # This is returning listings instead of users. Close but not it
  # has_many :hosts, :through => :reservations, :source => :listing

  # I need to create another association through trips to setup a path that
  # only access the hosts ids through your 'guest pathway'
  # Using source since I have a creatively named has_many :through association 
  has_many :trip_listings, :through => :trips, :source => :listing
  has_many :hosts, :through => :trip_listings, :foreign_key => :host_id

end


