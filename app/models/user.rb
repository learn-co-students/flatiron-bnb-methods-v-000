class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    listings = self.listings
    @host_reviews = []
    @guests = []
    unless listings.empty?
      listings.each do |listing|
        @guests << listing.guests.uniq
        @host_reviews << listing.reviews
      end
    end
    @guests.uniq.flatten if @guests
  end

  def hosts
    reservations = Reservation.where(guest_id: self.id)
    unless reservations.empty?
      reservations.collect do |reservation|
        Listing.find(reservation.listing_id).host
      end.uniq.flatten
    end
  end

  def host_reviews
    guests if @guests == nil
    @host_reviews.flatten if @host_reviews
  end


end
