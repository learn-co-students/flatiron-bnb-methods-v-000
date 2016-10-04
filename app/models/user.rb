class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guests = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        guests << Reservation.find_by(guest_id: reservation.guest_id).guest
      end
    end
    guests
  end

  def hosts
    hosts = []
    hosts << Reservation.find_by(guest_id: id).listing.host
  end

  def host_reviews
    reviews = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        reviews << reservation.review
      end
    end
    reviews
  end
end
