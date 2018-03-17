class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def hosts
    hosts = []
    trips.each { |t| hosts << User.find_by_id(Listing.find_by_id(t.listing_id).host_id) unless hosts.include? User.find_by_id(Listing.find_by_id(t.listing_id).host_id) }
    hosts
  end

  def guests
    guests = []
    reservations.each { |r| guests << User.find_by_id(r.guest_id) unless guests.include? User.find_by_id(r.guest_id)}
    guests
  end

  def host_reviews
    host_reviews = []
    reservations.each { |r| host_reviews << Review.find_by_id(reservations.first.review.id) unless host_reviews.include? Review.find_by_id(reservations.first.review.id) }
    host_reviews
  end

end
