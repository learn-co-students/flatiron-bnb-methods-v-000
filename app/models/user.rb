class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings, :foreign_key => 'guest_id'
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def host_reviews
    @reviews = []
    self.guests.each do |guest|
      guest.reviews.each do |rev|
        self.listings.each do |list|
          if list == rev.reservation.listing
            @reviews << rev
          end
        end
      end
    end
    @reviews.uniq
  end

  def guests
    @guest_list = []
      self.listings.each do |list|
        list.reservations.each do |rez|
          @guest_list << rez.guest
        end
      end
    @guest_list
  end

  def hosts
    @host_list = []
      self.trips.each do |trip|
        @host_list << trip.listing.host
      end
    @host_list.uniq
  end

  def to_host
    self.update(host: true)
  end

  def to_guest
    self.update(host: false)
  end  
end


# Official (much cleaner) solution
# class User < ActiveRecord::Base
#   has_many :listings, :foreign_key => 'host_id'
#   has_many :reservations, :through => :listings
#   has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
#   has_many :reviews, :foreign_key => 'guest_id'

#   ## As a guest
#   has_many :trip_listings, :through => :trips, :source => :listing
#   has_many :hosts, :through => :trip_listings, :foreign_key => :host_id

#   ## As a host
#   has_many :guests, :through => :reservations, :class_name => "User"
#   has_many :host_reviews, :through => :guests, :source => :reviews
# end