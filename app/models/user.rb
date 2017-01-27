class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.listings.collect {|x| x.guests}.flatten.uniq!
  end

  def hosts
    self.reviews.collect {|x| x.reservation.listing.host}
  end

  def host_reviews
    self.listings.collect {|x| x.reservations.collect {|y| y.review}}.flatten.compact
  end
end
