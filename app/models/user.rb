class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
   
  has_many :guests, through: :reservations, source: :guest

  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  
  #has_many :reverse_listings, through: :trips, source: :trip, class_name: "Listing" 
  #has_many :hosts, through: :reverse_listings, source: :host, class_name: "Listing"


  has_many :reviews, :foreign_key => 'guest_id'

  def hosts
  	trips.map {|trip| trip.listing.host}
  end

  def host_reviews
  	reservations.map {|r| r.review}
	end



  
end
