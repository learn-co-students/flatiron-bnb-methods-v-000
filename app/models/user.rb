class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  def guests
    r=[]
    listings.each do |l|
      l.guests.each do |g|
        r.append(g)
      end
    end
    r
  end
  def hosts
    r=[]
    Listing.all.each do |l|
      if l.guests.include?(self) then r.append(l.host) end
    end
    r
  end
  def host_reviews
    r=[]
    reservations.each do |res|
        r.append(res.review)
    end
    r
  end
end
