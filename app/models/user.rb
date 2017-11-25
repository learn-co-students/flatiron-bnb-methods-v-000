class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def hosts
    hosts = []
    self.trips.each do |reservation|
      hosts << reservation.listing.host
    end
    hosts
  end

  def guests
    guests = []
    self.reservations.each do |reservation|
      guests << reservation.guest
    end
    guests
  end

  def host_reviews
    self.reservations.map do |reservation|
      reservation.review
    end
  end

end
