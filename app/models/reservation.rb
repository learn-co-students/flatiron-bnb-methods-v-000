class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :own_listing?
  validate :valid_checkout_time?
  validate :unique_reservation?

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

  def own_listing?
    if guest_id == listing.host_id
      errors.add(:guest_id, "You cannot reserve your own listing")
    end
  end

  def unique_reservation?
    checkin != checkout
  end

  def valid_checkout_time?
    if !checkin.nil? && !checkout.nil?
      checkout < checkin
    end
  end
end
