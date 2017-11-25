class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'


  def guests
   @guests = []
   listings.each do |a|
     a.guests.each do |b|
       if !@guests.include?(b)
         @guests << b
       end
     end
   end
   @guests
 end

 def hosts
   @hosts = []
   trips.each do |a|
     @hosts << a.listing.host
   end
   @hosts
 end

 def host_reviews
   @reviews = []
   listings.each do |a|
     a.reviews.each do |b|
       if !@reviews.include?(b)
         @reviews << b
       end
     end
   end
   @reviews
 end

end
