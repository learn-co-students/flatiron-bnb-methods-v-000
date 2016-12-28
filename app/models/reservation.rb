class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  has_one :host, through: :listing
  validates :checkin, :checkout, presence: true
  validate :cannot_make_resevation_on_own_name
  validate :checkin_is_available, unless: 'self.checkin.nil? || self.checkout.nil?'
  validate :checkin_is_before_checkout, unless: 'self.checkin.nil? || self.checkout.nil?'
  validate :checkout_is_after_checkin

  def checkin_is_before_checkout
    unless self.checkin < self.checkout
      errors.add(:checkin_is_before_checkout, "checkin can not be before checkout!")
    end
  end

  def checkout_is_after_checkin
    unless self.checkin.nil? || self.checkout.nil? || self.checkout > self.checkin
      errors.add(:checkin_is_before_checkout, "checkin can not be before checkout!")
    end
  end



  def cannot_make_resevation_on_own_name
    if self.guest == self.listing.host
      errors.add(:cannot_make_resevation_on_own_name, "can not make reservation on own name!")
    end
  end

  def checkin_is_available
    query_range = checkin..checkout
    if listing.reservations.any? do |reservation|

        range = reservation.checkin..reservation.checkout
        range.overlaps?(query_range)
      end
      errors.add(:checkin_is_available, "checkin time is not available!")
    end
  end

  def duration
    (checkin..checkout).count - 1
  end

  def total_price
    listing.price.to_i * duration
  end

end
