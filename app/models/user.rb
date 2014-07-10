class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :foreign_key => 'guest_id'
  has_many :reviews, :foreign_key => 'guest_id'

  # Returns all guests (objects) a host has had
  # This might not be the best way to do this, if our database gets larger
  def guests
    self.listings.each do |listing|
      listing.reservations.collect do |reservation|
        reservation.guest
      end
    end
  end

  # Returns all hosts (objects) a guest has had
  def hosts
    self.reservations.each do |reservation|
      reservation.listing.host
    end
  end

  # Returns all of a host's reviews from their guests
  def host_reviews
    guests.collect do |guest|
      guest.reviews
    end
  end
end
