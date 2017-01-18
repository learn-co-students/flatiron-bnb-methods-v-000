class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :host_also_guest, :dates_available, :checkin_before_checkout

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  def passed?
    checkout <= Date.today
  end

  private
  def checkin_before_checkout
    if checkin? && checkout?
      unless checkin < checkout
        errors.add(:checkin, "must be before check out")
        errors.add(:checkout, "must be after check in")
      end
    end
  end

  def host_also_guest
    if guest_id == listing.host_id
      errors.add(:guest_id, "host cannot reserve their own listing")
    end
  end

  def dates_available
    if other_reservations_on_date(checkin).any?
      errors.add(:checkin, "is not available")
    elsif other_reservations_on_date(checkout).any?
      errors.add(:checkout, "is not available")
    end
  end

  def other_reservations_on_date(date)
    listing.reservations.where.not(id: id).where(
      "checkin <= :date AND :date <= checkout",
      date: date
    )
  end
end

