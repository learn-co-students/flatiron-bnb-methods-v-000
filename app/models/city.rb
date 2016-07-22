class City < ActiveRecord::Base
  include Reservable::InstanceMethods
  extend Reservable::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end

  # def city_openings(start_date, end_date)
  #   checkin_date, checkout_date = (Date.parse start_date), (Date.parse end_date)
  #   listings.each do |listing|
  #     listing.reservations.each do |r|
  #       checkin_date <= r.checkout && checkout_date >= r.checkin
  #     end
  #   end
  # end

end
