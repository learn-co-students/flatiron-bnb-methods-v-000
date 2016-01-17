class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validates_with ReservationsHelper::GuestUniqueFromHostValidator
  validates_with ReservationsHelper::ListingAvailabilityValidator
  validates_with ReservationsHelper::OutAfterInValidator

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price.to_f
  end

end
