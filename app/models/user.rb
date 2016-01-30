class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :host_reviews, :through => :reservations, source: :review


  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  
  def hosts
  	trips.map{|trip| trip.listing.host}
  end

  def guests
  	reservations.map{|res| res.guest }
  end



end
