class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    array = []
    self.listings.each do |list|
      list.reservations.each do |res|
        array << res.guest
      end
    end
    array.flatten
  end

  def hosts
    array =[]
    self.trips.each do |viaje|
      array << viaje.listing.host
    end
    array
  end

  def host_reviews
    array = []
    self.listings.each do |list|
      array << list.reviews
    end
    array.flatten
  end

end
