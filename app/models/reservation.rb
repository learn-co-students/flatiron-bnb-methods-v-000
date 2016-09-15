class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :same_day
  validate :checkin_before_checkout
  validate :same_person
  validate :available

  def same_day
    if checkin == checkout
      errors.add(:reservation, "Please check your dates.")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkout < checkin
      errors.add(:reservation, "Checkout date must be after checkin date.")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  def same_person
    if guest_id == listing.host_id
      errors.add(:reservation, "You cannot reserve your own property.")
    end
  end

  def available
    if self.checkin && self.checkout != nil
      listing = self.listing
      listing.reservations.each do |reservation|
        if reservation != self
          if self.checkin.between?(reservation.checkin, reservation.checkout)
            errors.add(:avialable, "This listing is already reserved.")
          elsif self.checkout.between?(reservation.checkin, reservation.checkout)
              errors.add(:avialable, "This listing is already reserved.")
            end
          end
        end
    end
  end

end
