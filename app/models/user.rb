class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.listings.collect do |listing|
      listing.guests.each do |guest|
        guest
      end.uniq
    end.flatten
  end

  def hosts
    self.trips.collect do |trip|
      trip.listing.host
    end
  end

  def host_reviews
    self.listings.collect do |listing|
      listing.reviews.each do |review|
        review
      end
    end.flatten
  end

end
