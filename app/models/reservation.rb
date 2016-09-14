class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_and_host_not_the_same, :check_if_listing_is_available_at_checkin_before_making_reservation
  validate :checkin_is_before_checkout, :checkin_and_checkout_are_different

  def duration
    (self.checkout-self.checkin).to_i
  end

  def total_price
    self.listing.price.to_f * duration
  end

  private

  def guest_and_host_not_the_same
    if listing.host_id == self.guest_id
      errors.add(:guest_id, "can't be the same as listing_id")
    end
  end

  # this method checks the reservations on the current listing, to see if the dates are already taken or not
  def check_if_listing_is_available_at_checkin_before_making_reservation
    self.listing.reservations.each do |reservation|
      range = (reservation.checkin..reservation.checkout)
      if range.include?(checkin) || range.include?(checkout)
        errors.add(:guest_id, "the listing is not available for desired reservation dates")
      end
    end
  end

  def checkin_is_before_checkout
    # make sure it hasn't failed any other validations before getting to this one
    # why doesn't the validation fail if no checkout date is present?
    return unless errors.empty?

    if self.checkin > self.checkout
      errors.add(:checkin, "the checkin date is after the checkout date")
    end
  end

  def checkin_and_checkout_are_different
    if self.checkin === self.checkout
      errors.add(:checkin, "the checkin date and the checkout date are the same")
      # {checkin: [{error: "the checkin date and the checkout date are the same"}]}
    end
  end

end