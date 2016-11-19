class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.reservations.map{|r| User.find(r.guest_id)}
  end

  def hosts
    self.reviews.map{|r| User.find(r.reservation.listing.host_id)}
  end

  def host_reviews
    review_collection = []
    guests.each do |g|
      g.reviews.each do |r|
        review_collection << r
      end
    end
    review_collection
  end
end
