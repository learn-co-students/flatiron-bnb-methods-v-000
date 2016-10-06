class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def host_listings
    Listing.where(:host_id == self.id)
  end
  
  def guests
    all_guests = []
    self.host_listings.each do |listing|
      all_guests << listing.guests
    end
    all_guests.flatten
  end

  def guest_reservations
    Reservation.where(:guest_id == self.id)
  end

  def hosts
    all_hosts = self.guest_reservations.collect {|reservation| reservation.listing.host }
  end

  def host_reviews
    all_reviews = self.host_listings.collect {|listing| listing.reviews}
    all_reviews.flatten
  end

  
end
