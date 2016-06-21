class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :guest_is_not_host, :available, :checkout_time

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * duration
  end

  private

  def guest_is_not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "Guest and host cannot be the same.")
    end
  end

  def available
    self.listing.reservations.each do |res|
      booked_dates = res.checkin..res.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest_id, "Those dates have already been booked.")
      end
    end
  end

  def checkout_time
    if self.checkin && self.checkout
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Checkout time must be after checkin time.")
      end
    end
  end

end
