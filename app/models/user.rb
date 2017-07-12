class User < ActiveRecord::Base
	has_many :listings, :foreign_key => 'host_id'
	has_many :reservations, :through => :listings
	has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
	has_many :reviews, :foreign_key => 'guest_id'

	# As a host
	has_many :guests, through: :reservations, :foreign_key => :guest_id
		# Alias:     has_many :guests, :through => :reservations, :class_name => "User"
		# Because	 :reservation belongs_to :guest, :class_name => "User"
	has_many :host_reviews, through: :listings, source: :reviews
		# we create an alias method for .reviews as .host_reviews
		# Because	:listing has_many :reviews, :through => :reservations

	# As a guest
	has_many :trip_listings, through: :trips, source: :listing
		# creates a .trip_listings method to know about the listing a guest has had through trips (reservations) 
	has_many :hosts, through: :trip_listings, foreign_key: :host_id

end
