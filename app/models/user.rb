require 'pry'

class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    reservations.map { |res| res.guest }
  end

  def hosts
    reviews.map { |rev| rev.reservation.listing.host }
  end

  def host_reviews
    reservations.map { |res| res.review }
  end
end
