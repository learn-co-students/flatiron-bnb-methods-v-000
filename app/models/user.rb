class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def host?
    Listing.all.each do |listing|
      host_ids = []
      host_ids << listing.host_id
      
      if host_ids.include?(self.id)
        self.host = true
      else
        self.host = false
      end
    end
    self.host
  end

  def guests
    hosts_guests = []

    self.reservations.each do |reservation|
      hosts_guests << User.find(reservation.guest_id)
    end
    hosts_guests.uniq
  end

  def hosts
    guests_hosts = []

    self.trips.each do |reservation|
      guests_hosts << User.find(reservation.listing.host_id)
    end
    guests_hosts.uniq
  end

  def host_reviews
    host_reviews = []

    self.reservations.each do |reservation|
      host_reviews << reservation.review
    end
    host_reviews
  end



end
