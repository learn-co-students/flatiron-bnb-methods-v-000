class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    if reservations.any?
      reservations.map {|reservation| reservation.guest}
    end
  end

  def hosts
    if trips.any?
      trips.map {|trip| trip.listing.host}
    end
  end

  def host_reviews
    if self.guests.any?
      self.guests.flat_map do |guest|
        if guest.reviews.any?
          guest.reviews
        end
      end
    end
  end
end
