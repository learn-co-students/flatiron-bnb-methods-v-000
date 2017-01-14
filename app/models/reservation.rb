class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :host_also_guest?
  validate :checkin_available?
  validate :checkout_available?
  validate :checkin_before_checkout?

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  def checkin_available?
    if other_reservations_on_date?(checkin)
      errors.add(:checkin, "is not available")
    end
  end

  def checkout_available?
    if other_reservations_on_date?(checkout)
      errors.add(:checkout, "is not available")
    end
  end

  def checkin_before_checkout?
    if checkin? && checkout?
      unless checkin < checkout
        errors.add(:checkout, "must be after check in")
      end
    end
  end

  def host_also_guest?
    if guest_id == listing.host_id
      errors.add(:guest_id, "host cannot reserve their own listing")
    end
  end

  def other_reservations_on_date(date)
    listing.reservations.where.not(id: id).where(
      "checkin <= :date AND :date <= checkout",
      date: date
    )
  end

  def other_reservations_on_date?(date)
    other_reservations_on_date(date).any?
  end
end

