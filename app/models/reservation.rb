class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin,  presence: true
  validates :checkout, presence: true
  validate  :consistent_dates
  validate  :host_and_guest_are_different
  validate  :check_availability

  # does the supplied date range conflict with any reservation in the given collection?
  def self.has_conflict?(reservations, start_date, end_date)
    reservations.detect { |reservation| reservation.date_conflict?(start_date, end_date) }
  end

  # does this reservation's date range conflict with any reservation in the given collection?
  def has_conflict?(reservations)
    reservations.detect { |reservation| reservation.date_conflict?(checkin, checkout) if reservation != self }
  end

  def date_conflict?(start_date, end_date)
    if checkin && checkout && start_date && end_date
      checkin <= end_date && checkout >= start_date
    else
      false
    end
  end

  def duration
    checkin && checkout ? checkout - checkin : 0
  end

  def total_price
    listing.price * duration.to_f
  end

private

  def check_availability
    if has_conflict?(listing.reservations)
      errors.add(:reservation, "has one or more dates that are not available")
    end
  end

  # the listing owners are not allowed to rent their own places.
  def consistent_dates
    if checkout && checkin && checkout <= checkin
      errors.add(:checkout, "must be later than checkin")
    end
  end

  # the listing owners are not allowed to rent their own places.
  def host_and_guest_are_different
    if guest == listing.host
      errors.add(:guest, "cannot be the same as the host")
    end
  end
end
