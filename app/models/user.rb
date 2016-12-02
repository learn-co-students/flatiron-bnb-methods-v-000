class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, through: :reservations



  def hosts
    hosts = []

    self.trips.each do |trip|
      hosts << trip.listing.host
    end

    hosts
  end


  def host_reviews
    host_reviews = []

    self.reservations.each do |rez|
      if rez.review
        host_reviews << rez.review
      end
    end

    host_reviews  
  end




end
