class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    reservations.collect { |reservation| reservation.guest }
  end

  def hosts
    trips.collect { |trip| trip.listing.host }
  end

  def host_reviews
    all_host_reviews = guests.collect do |guest| 
      guest.reviews.select do |review|
        review.reservation.listing.host == self
      end
    end
    all_host_reviews.flatten
  end
  
end
