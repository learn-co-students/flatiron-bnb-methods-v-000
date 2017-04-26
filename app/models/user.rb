class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id' #has listings as host
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation" #has trips as guest
  has_many :reviews, :foreign_key => 'guest_id'
  # @user.trips << an array of reservations where the user's id matches the guest id
  # has_many :host_reviews, :foreign_key => 'guest_id', :class_name => "Review"

  has_many :guests, through: :reservations, class_name: :User #as a host, knows about guests it's had
  # we creates an query called trip_listings, since trips are places a guest would have gone, we go through: the trips query. We source listing since a trip is a reservation and a reservation belongs to a listing (relationship)
  has_many :trip_listings, through: :trips, source: :listing
  # we then create a hosts array, since we have the listings that the trips reservations belong to, we can pick out the host_id
  # we do it this way due to guest being further away (connected wise with association) in order to connect the two together.
  has_many :hosts, through: :trip_listings, :foreign_key => 'host_id'

  has_many :host_reviews, through: :listings, source: :reviews

  # def hosts
  #   self.trips.map {|trip| User.find(trip.id)}
  # end
  #
  # def host_reviews
  #   self.guests.map {|guest| guest.reviews}.flatten.uniq
  # end
end
