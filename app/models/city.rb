require 'concerns/extra_reservation_info'

class City < ActiveRecord::Base
  include ReservationHelpers::InstanceMethods
  extend ReservationHelpers::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def reservations
  	city_reservations = []
  	self.listings.each do |listing|
  		city_reservations << listing.reservations
  	end
  	city_reservations.flatten
  end

end

