class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :trips, :class_name => "Reservation", :foreign_key => 'guest_id'
  has_many :reservations, :through => :listings, :foreign_key => 'host_id'
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    guest_list = []
    listings.each { |listing|
      listing.reservations.each { |reservation|
        guest_list << reservation.guest
      }
    }
    guest_list.uniq
  end

  def hosts
    host_list = []
    trips.each { |trip|
      host_list << trip.listing.host
    }
    host_list.uniq
  end

    def host_reviews
      review_list = []
      listings.each { |listing|
        listing.reservations.each { |reservation|
          review_list << reservation.review
        }
      }
      review_list
    end
end
