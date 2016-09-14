class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :checkin_before_checkout?, if: "checkin.present? && checkout.present?"
  validate :checkin_different_than_checkout?, if: "checkin.present? && checkout.present?"
  validate :not_your_listing?
  validate :available


  delegate :host, to: :listing, :allow_nil => true

  
  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  def available
    self.listing.reservations.each do |res|
      booked = (res.checkin..res.checkout).to_a
      if (booked.include?(self.checkin) || booked.include?(self.checkout))
        errors.add(:reservation, "These dates are not available.")
      end
    end
  end


  private

  def checkin_before_checkout?
    if checkin > checkout 
      errors.add(:reservation, "Checkin must be before checkout.")
    end
  end

  def checkin_different_than_checkout?
    if checkin == checkout
      errors.add(:reservation, "Checkin and checkout cannot be the same day.")
    end
  end

  def not_your_listing?
    if guest_id == listing.host_id
      errors.add(:reservation, "You cannot reserve your own listing.")
    end
  end


end
