class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :reservation_cannot_be_on_your_own_listing
  validate :listing_must_be_available_at_checkin_before_making_reservation
  validate :listing_must_be_available_at_checkout_before_making_reservation
  validate :checkin_is_before_checkout
  validate :checkin_and_checkout_are_different_dates

  def openings(start_date, end_date)
    self.checkin > end_date && self.checkout < start_date
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.duration * self.listing.price
  end

  private

  #############_methods_for_validation############

  def reservation_cannot_be_on_your_own_listing
    if self.listing.host_id == self.guest_id
      errors.add(:self, "cannot be on your own listing")
    end
  end

  def listing_must_be_available_at_checkin_before_making_reservation
    self.listing.reservations.each do |reservation|
      if self.checkin && self.checkin.between?(reservation.checkin, reservation.checkout)
        errors.add(:listing, "must be available at checkin before making reservation")
      end
    end
  end

  def listing_must_be_available_at_checkout_before_making_reservation
    self.listing.reservations.each do |reservation|
      if self.checkout && self.checkout.between?(reservation.checkin, reservation.checkout)
        errors.add(:listing, "must be available at checkout before making reservation")
      end
    end
  end

  def checkin_is_before_checkout
    if self.checkin && self.checkout && self.checkin > self.checkout
      errors.add(:checkout, " must be after checkin")
    end
  end

  def checkin_and_checkout_are_different_dates
    if self.checkin && self.checkout && self.checkin == self.checkout
      errors.add(:checkin, " and checkout can't be on the same day")
    end
  end

end
