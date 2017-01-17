class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  # def overlapping_reservations
  #   listing.reservations.where(
  #     "checkin <= :end_date AND :start_date <= checkout",
  #     start_date: checkin,
  #     end_date: checkout,
  #   )
  # end
end
