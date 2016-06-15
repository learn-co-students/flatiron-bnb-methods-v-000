class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  #has_many :hosts, through: :reservations, :class_name => "User" 

  
  def guests
    self.reservations.collect{|reservation| reservation.guest}
  end

  def hosts
  end

  def host_reviews
    #self.guest
  end

end
