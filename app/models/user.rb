class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.reservations.collect {|g| User.find(g.guest_id)}.uniq
  end

  def hosts
    self.trips.collect {|h| User.find(h.listing.host_id)}.uniq
  end

  def host_reviews
    self.reservations.collect {|r| r.review}
  end

end
