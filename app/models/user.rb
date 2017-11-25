class User < ActiveRecord::Base
  #Host
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, :through => :listings
  #Guest
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :lodgings, :class_name => "Listing", :through => :trips, :source => :listing
  has_many :hosts, :through => :lodgings

  def host_reviews
    reviews = []
    self.guests.each do |guest|
      guest.reviews.each do |review|
        reviews << review
      end
    end
    reviews
  end

end
