class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guests = []
    Listing.all.each do |listing|
      if id == listing.host_id
        listing.reservations.each do |reservation|
          guests << User.find_by_id(reservation.guest_id)
        end
      end
    end
    guests
  end

  def hosts
    hosts = []
    Listing.all.each do |listing|
      listing.reservations.each do |reservation|
        if id == reservation.guest_id
          hosts << User.find_by_id(reservation.listing.host_id)
        end
      end
    end
    hosts.uniq
  end

  def host_reviews
    reviews = []
    Review.all.each do |review|
      if id == review.reservation.listing.host_id
        reviews << review
      end
    end
    reviews.uniq
  end
  
end
