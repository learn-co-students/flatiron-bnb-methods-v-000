class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :host, through: :listing, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_id_cannot_be_host_id
  validate :checkin_is_before_checkout
  validate :checkin_is_not_checkout
  validate :reservation_available_checkin
  validate :reservation_available_checkout

  def guest_id_cannot_be_host_id
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "can't be same as host_id")
    end
  end

  def checkin_is_before_checkout
    if self.checkin && self.checkout
      if self.checkin > self.checkout
        errors.add(:checkin, "must be before checkout")
      end
    end
  end

  def checkin_is_not_checkout
    if self.checkin && self.checkout
      if self.checkin == self.checkout
        errors.add(:checkin, "must be different from checkout")
      end
    end
  end

  def reservation_available_checkin
    if self.checkin && self.checkout
      self.listing.reservations.each do |res|
        if self.checkin <= res.checkout
          errors.add(:checkin, "listing not yet available")
        end
      end
    end
  end

  def reservation_available_checkout
    if self.checkin && self.checkout
      self.listing.reservations.each do |res|
        if self.checkout <= res.checkin
          errors.add(:checkin, "listing cannot overlap")
        end
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end
end
