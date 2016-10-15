class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'



  def guests
    guests = [] 
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        guests << User.find(reservation.guest_id)
      end
    end
    guests
  end

  # self.reservations.map {|reservation| reservation.guest}

  def hosts
    all_hosts = [] 
    self.trips.each do |trip|  #trip being a reservation
      listing = Listing.find(trip.listing_id) # find the listing of your reservation
      host = User.find(listing.host_id) # find the host of that listings reservation
      all_hosts << host 
    end
    all_hosts 
  end

  # self.trips.map {|rsvp| rsvp.listing.host}

  def host_reviews
    all_reviews = []

    self.listings.each do |listing|
      listing.reservations.each do |reservation|
      all_reviews << reservation.review
      end
    end
    all_reviews 
  end

  # has_many :host_reviews, through: :reservations, source: :review  
  # => harnessese a host_review by digging
  # direct into a reservation object and calling "source" which is 
  # a method in the table, in this case
  # the review

  
end
