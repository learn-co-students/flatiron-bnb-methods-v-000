class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  #linds
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :guests, :source => :reviews
  has_many :trip_listings, :through => :trips, :source => :listing
  has_many :hosts, :through => :trip_listings, :foreign_key => :host_id
  ######


  #has_many :hosts, through: :reservations, :class_name => "User" 
  #has_many :trip_listings, :through => :trips, :source => :listing
  #has_many :hosts, :through => :trip_listings, :foreign_key => :host_id

  
#  def guests
#    self.reservations.collect{|reservation| reservation.guest}
#  end
#  def hosts
#    self.reservations.collect{|reservation| reservation.listing.host}
#    #@amanda.reservations.first.listing.host
#  end
#  def host_reviews
#    #self.guest
#  end

end
