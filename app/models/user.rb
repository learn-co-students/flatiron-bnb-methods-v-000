class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :host_reviews, :through => :reservations, source: :review

  def guests
    reservations.map{|f| f.guest }
    #binding.pry
  end

  def hosts
    trips.map {|trip| trip.listing.host}
  end
end
