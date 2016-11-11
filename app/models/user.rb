class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  before_save :toggle_host

  def toggle_host
      if !!self.listings
          self.host = true
      else
          self.host = false
      end
  end

  def hosts
      self.trips.collect { |t| t.listing.host }
  end

  def guests
      self.reservations.collect { |r| r.guest }
  end

  def host_reviews
      guests.collect { |g| g.reviews }.flatten
  end
end
