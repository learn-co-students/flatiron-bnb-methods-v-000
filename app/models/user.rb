class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  

  def guests
    reservations.guests_list
  end

  def hosts
    trips.hosts_list
  end

  def host_reviews
    reservations.all_reviews
  end
  
end