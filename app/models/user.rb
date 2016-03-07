class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'


  def guests
    guest = self.listings.collect {|d| User.find(Reservation.find_by(listing_id: Listing.find_by(host_id: d.id)).guest_id)}
  end

  def hosts
    host = self.trips.collect {|t| User.find(Listing.find(Reservation.find_by(guest_id: self.id).listing_id).host_id)}
  end

  def host_reviews
    my_reviews = self.guests.collect {|rev| Review.find_by(guest_id: rev.id) }
  end
end
