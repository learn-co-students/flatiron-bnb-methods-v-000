class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  #as a host, knows about guests
  has_many :guests, through: :reservations, class_name: 'User'

  #as a guest, knows about hosts
  has_many :trip_listings, through: :trips, source: :listing
  has_many :hosts, through: :trip_listings, foreign_key: :host_id

  #as a host, knows about reviews from guests
  has_many :host_reviews, through: :guests, source: :reviews

end
