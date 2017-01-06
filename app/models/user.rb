class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guest_list = []
    self.listings.each do |listing|
      listing.guests.each do |guest|
        guest_list << guest
      end
    end
    guest_list
  end

  def hosts
    host_list = []
    self.trips.each do |trip|
      listing = Listing.find(trip.listing.id)
      host_list << User.find(listing.host_id)
    end
    host_list
  end

  def host_reviews
    review_list = []
    self.guests.each do |guest|
      guest.reviews.each do |review|
        review_list << review
      end
    end
    review_list
  end

end
