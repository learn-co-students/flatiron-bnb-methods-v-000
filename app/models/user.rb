class User < ActiveRecord::Base
  ## See solution for cleaner and more descriptive methods :)

  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  ## As a guest
  has_many :trip_listings, through: :trips, source: :listing
  has_many :hosts, through: :trip_listings

  ## As a host
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :guests, source: :reviews

  ### For an explanation on the use of :source in has_one/has_many, through: association: http://stackoverflow.com/questions/4632408/need-help-to-understand-source-option-of-has-one-has-many-through-of-rails#
  
end
  