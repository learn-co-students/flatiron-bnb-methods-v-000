class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, through: :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :listings
  has_many :hosts, through: :trips
  has_many :host_reviews, through: :listings, source: :reviews

  def hosts
    trips.map {|trip| trip.listing.host}
  end

  def guests
    reservations.map {|res| res.guest}
  end

end
