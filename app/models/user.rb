class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def guests
    self.reservations.map do |reservation|
      reservation.guest 
    end
  end

  def hosts
    self.trips.map do |trip|
      trip.listing.host 
    end
  end

  def host_reviews
    self.reservations.map do |reservation|
      reservation.review 
    end
  end
end
