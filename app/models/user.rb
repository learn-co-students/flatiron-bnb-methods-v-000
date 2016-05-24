class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  has_many :guests, through: :reservations
  has_many :destinations, through: :trips, source: :listing
  has_many :hosts, through: :destinations

  has_many :host_reviews, through: :reservations, source: :review

  def update_host_status
    if listings.any? 
      update(host: true)
    else
      update(host: false)
    end
  end
end
