class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def listings
  	Listing.where(host_id: "#{self.id}")
  end

  def reservations
  	self.listings.reservations
  end
  
end
