class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def guests
    guest_array = []
    self.listings.each do |listing|
      listing.guests.each do |guest|
        guest_array << guest
      end
    end
    guest_array.uniq
  end

  def hosts
    host_array = []
      self.trips.each do |trip|
        host_array << trip.listing.host
      end
    host_array.uniq
  end

  def host_reviews
    reviews_array = []
    
    self.listings.each do |listing|
      listing.reviews.each do |review|
        reviews_array << review
      end
    end
    reviews_array
  end











end
