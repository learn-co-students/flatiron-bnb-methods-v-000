class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    listing = Listing.find_by(host_id: self.id)
    listing.guests
  end

  def hosts
    reservations = Reservation.all.select {|res| res.guest_id == self.id }
    reservations.map do |res|
      User.find_by_id(Listing.find_by_id(res.listing_id).id)
    end
  end

  def host_reviews

    reviews = []

    self.guests.each do |guest|
      Review.all.each do |rev|
        if rev.guest_id == guest.id
          reviews << rev
        end
      end
    end
    reviews
  end

end
