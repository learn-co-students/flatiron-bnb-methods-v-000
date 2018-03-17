class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  has_many :guests, :class_name => "User", :through => :reservations

  # need to clarify
  has_many :wtf_join, :through => :trips, :source => :listing
  has_many :hosts, :through => :wtf_join, :foreign_key => :host_id

  has_many :host_reviews, through: :guests, source: :reviews
end
