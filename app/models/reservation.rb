class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_own_listing
  validate :in_before_out
  validate :available



  def in_before_out
    if checkin && checkout
      if self.checkin > self.checkout || self.checkin == self.checkout
      errors.add(:guest_id, "Checkin date must be before checkout.")
      end
    end
  end

  def available
    dates = [checkin, checkout]

    self.listing.reservations.each do |list|
      dates.each do |date|
        if (list.checkin..list.checkout).include?(date)
          errors.add(:guest_id, "These dates are not available")
        end
      end
    end
  end

  def not_own_listing
    if !(self.listing.host_id != self.guest_id)
      errors.add(:guest_id, "You cannot reserve your own listing.")
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * duration
  end

end
