class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations, :class_name => "User"
  has_many :hosts, through: :trips, :source => 'listing', :class_name => "User"


  def host_reviews
    reviews = []
    reservations.each do |res|
      reviews << res.review
      end
    reviews
  end

  
end
