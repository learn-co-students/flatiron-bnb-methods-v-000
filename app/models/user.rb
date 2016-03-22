class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  # Returns all of the guests a user has had as a host
  def guests 
    @guests = self.reservations.collect do |res|
      res.guest
    end
  end
  
  # Returns all of the hosts a user has had as a guest
  def hosts 
    @hosts = self.trips.collect do |trip|
      trip.listing.host
    end
  end
  
  # returns all of the reviews a host has received from guests
  def host_reviews 
    @host_reviews = []
    self.reservations.each do |res| 
      if res.review 
        @host_reviews << res.review
      end
    end
    @host_reviews
  end
  
end
