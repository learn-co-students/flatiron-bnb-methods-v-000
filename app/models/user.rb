class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  

  def guests
  	@listings = self.listings
  	@guests = []
  	@listings.map do |l|
  		@reservations = l.reservations
  		@reservations.map do |r|
  			@guests << r.guest
  		end
  	end
  	@guests
  end

  def hosts
  	@reservations = Reservation.all
  	@hosts = []
  	@reservations.map do |r|
  		if r.guest_id == self.id
  			@hosts << r.listing.host
  		end
  	end
  	@hosts
  end

  def host_reviews
  	@listings = self.listings
  	@reviews = []
  	@listings.map do |l|
  		@reservations = l.reservations
  		@reservations.map do |r|
  			@reviews << r.review
  		end
  	end
  		@reviews
  end



end
