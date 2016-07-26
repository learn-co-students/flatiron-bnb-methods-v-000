class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.reservations.collect do |reservation|
      reservation.guest
    end
  end 

  def hosts
    self.trips.collect do |trip|
      trip.listing.host
    end
  end
  
  def host_reviews
    @reviews = []
    self.guests.each do |guest| 
      guest.reviews.each do |review| 
        @reviews << review
      end
    end
    @reviews
  end

  def set_host_to_true
    self.update(host: true)
  end

  def set_host_to_false
    self.update(host: false)
  end
end
