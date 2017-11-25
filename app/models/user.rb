class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.reservations.map do |r|
      r.guest
    end
  end

  def hosts
    self.trips.map do |t|
      t.listing.host
    end
  end

  def host_reviews
    ans = []
    self.listings.each do |l|
      l.reviews.each {|r| ans << r}
    end
    ans
  end
  
end
