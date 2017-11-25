class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def host_reviews
    host_reviews = []
    reservations.each { |res| host_reviews << Review.find_by_id(reservations.first.review.id) unless host_reviews.include? Review.find_by_id(reservations.first.review.id) }
    host_reviews
  end

  def hosts
    hosts = []
    trips.each { |trip| hosts << User.find_by_id(Listing.find_by_id(trip.listing_id).host_id) unless hosts.include? User.find_by_id(Listing.find_by_id(trip.listing_id).host_id) }
    hosts
  end

  def guests
    guests = []
    reservations.each { |res| guests << User.find_by_id(res.guest_id) unless guests.include? User.find_by_id(res.guest_id) }
    guests
  end
end
