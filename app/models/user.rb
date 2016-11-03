class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def make_host
    self.host = true
    save
  end

  def make_guest
    self.host = false
    save
  end

  def guests
    reservations.collect do |reservation|
      reservation.guest
    end
  end

  def hosts
    Reservation.all.collect do |reservation|
      if reservation.guest_id == id
        reservation.listing.host
      end
    end
  end

  def host_reviews
    reservations.collect do |reservation|
      reservation.review
    end
  end
end
