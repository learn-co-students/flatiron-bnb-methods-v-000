class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def guests
  	guests = []
  	reservations.each { |reserve| guests << User.find_by_id(reserve.guest_id) }
  	guests
  end

  def hosts
  	hosts = []
  	trips.each { |trip| hosts << User.find_by_id(Listing.find_by_id(trip.listing_id).host_id) }
  	hosts
  end

  def host_reviews
  	host_reviews = []
  	reservations.each { |reserve| host_reviews << Review.find_by_id(reservations.first.review.id)}
  	host_reviews
  end

end
