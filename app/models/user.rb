class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :listings

  def hosts
    trips.map{|x| x.listing.host}.flatten
  end

  def host_reviews
    listings.map{|x| x.reviews}.flatten
  end
end
