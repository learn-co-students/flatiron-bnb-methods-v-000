class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def change_user_host_status
    self.host = true
  end

  def guests
    reservations.collect do |res|
      res.guest
    end
  end

  def hosts
    self.trips.collect do |res|
       res.listing.host
    end
  end

  def host_reviews
    guests.collect do |guest|
      guest.reviews
    end.flatten
  end

end
