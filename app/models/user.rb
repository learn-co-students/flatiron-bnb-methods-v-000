class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :host_reviews, through: :reservations, source: :review

  def guests
    self.reservations.map {|reservation| reservation.guest}
  end

  def hosts
    self.trips.map {|reservation| reservation.listing.host}
  end

end
