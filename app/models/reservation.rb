class Reservation < ActiveRecord::Base
  # Associations
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  # Validations
  validates_presence_of :checkin, :checkout
  validate :guest_user, :valid_dates


  # Duration of resevation
  def duration
    (self.checkout - self.checkin).to_i
  end

  # Total resevation price
  def total_price
    self.duration * self.listing.price
  end

  private

  # Prevent host from making a resevation
  def guest_user
    if self.guest == self.listing.host
      errors.add(:guest, "Host can not make a resevation")
    end
  end

  # Checkout and checkin validations
  def valid_dates
    # Validate checkin date availability
    if self.checkin && !available_on?(self.checkin)
      errors.add(:checkin, "Unavailable checkin date")
    end

    # Validate checkout date availability
    if self.checkout && !available_on?(self.checkout)
      errors.add(:checkout, "Unavailable checkout date")
    end

    # Validate order of dates
    if self.checkin && self.checkout
      if self.checkin >= self.checkout
        errors.add(:checkout, "Checkout date can not be ealier or on the same date as checkin")
      end
    end
  end

  def available_on?(date)
    where_sql = "? BETWEEN reservations.checkin AND reservations.checkout"
    taken_count = listing.reservations.where(where_sql, date).count

    self.new_record? ? taken_count == 0 : taken_count == 1
  end
end
