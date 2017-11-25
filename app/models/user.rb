class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guest_list = []
    listings.each do |listing|
      listing.reservations.each do |reservation|
        guest_list << reservation.guest
      end
    end
    guest_list
  end

  def hosts
    host_list = []
    trips.each do |trip|
      host_list << trip.listing.host
    end
    host_list
  end

  def host_reviews
    review_list = []
    listings.each do |listing|
      listing.reservations.each do |reservation|
        review_list << reservation.review
      end
    end
    review_list
  end

end
