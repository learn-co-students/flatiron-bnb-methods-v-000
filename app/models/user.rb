class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guests = Array.new
    listings.each do |l|
      l.reservations.each {|r| guests << User.find(r.guest_id)}
    end
    guests
  end

  def hosts
    hosts = Array.new
    trips.each do |t|
      hosts << User.find(t.listing.host_id)
    end
    hosts
  end

  def host_reviews
    reviews = Array.new
    guests.each do |g|
      g.reviews.each {|r| reviews << r}
    end
    reviews
  end

end
