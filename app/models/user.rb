class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  # as a host, knows about the guests it's had
  def guests
    arr = []

    self.reservations.each do |reservation|
      arr << User.find(reservation.guest_id)
    end

    arr
  end

  # as a guest, knows about the hosts it's had
  # searches each of the guest's reservations, finds each host, and pushes them into []
  def hosts
    arr = []

    self.trips.each do |reservation|
      arr << User.find(reservation.listing.host_id)
    end

    arr
  end

  # as a host, knows about its reviews from guests
  def host_reviews
    reviews = []
    
    self.reservations.each do |reservation|
      reviews << Review.find_by(guest_id: reservation.guest_id)
    end

    reviews
  end
end