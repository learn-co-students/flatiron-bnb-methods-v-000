class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'



  def hosts
    trips.collect {|t| t.listing.host}
  end

  def guests
    reservations.collect {|r| r.guest}
  end

  def host_reviews
    reservations.collect {|r| r.review}
  end



end
