class User < ActiveRecord::Base
  # Host
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, through: :reservations
  has_many :host_reviews, class_name: 'Review', through: :reservations, source: :listing

  # Guest
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :trip_listings, class_name: 'Listing', through: :trips, source: :listing
  has_many :hosts, through: :trip_listings

  def is_a_host
    update host: true
  end

  def is_not_a_host
    update host: false
  end
end
