class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'


def guests
  all_guests = []
  reservations.each do |res|
    all_guests << res.guest
  end

  all_guests
end

def hosts
  all_hosts = []
  # binding.pry
  trips.each do |trip|
    all_hosts << trip.listing.host
  end

  all_hosts
end

def host_reviews
  all_reviews = []

  listings.each do |l|
    l.reviews.each do |rev|
      all_reviews << rev
    end
  end

  all_reviews
end

end
