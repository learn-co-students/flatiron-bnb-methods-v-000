class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations, class_name: 'User'
  has_many :host_reviews, through: :guests, source: :reviews
=begin  
  def guests
    total_guests = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        total_guests << reservation.guest 
      end
    end
    total_guests
  end
=end  
  def hosts
    all_hosts = []
    self.trips.each do |trip|
        all_hosts << trip.listing.host 
    end
    all_hosts
  end
  
  
  
end
