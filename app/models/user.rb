class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    the_guests = []
    listings.each { |l|
      l.reservations.each { |r|
        the_guests << r.guest unless the_guests.include?(r.guest)
      }
    }
    the_guests
  end

  def hosts
    trips.collect { |r| r.host }.uniq
  end

  def host_reviews
    reservations.collect { |r| r.review }
  end
end
