class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  include ActiveModel::Validations
  validates_with GuestIsNotHost
  validates_with ListingIsAvailable
  validates_with CheckinComesBeforeCheckout
  validates :checkin, presence: true
  validates :checkout, presence: true

  def duration
    checkout - checkin
  end

  def total_price
    listing.price*duration
  end

end
