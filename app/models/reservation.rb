class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_yours
  validate :available
  validate :in_before_out
  validate :duration_zero


  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end

private

  def not_yours
    if self.listing.host_id == self.guest_id
       errors.add(:guest, "Cannot reserve your own listing")
    end
  end

  def available
    if self.checkin && self.checkout
      self.listing.reservations.each do |r|
        if self.checkin <= r.checkout && r.checkin <= self.checkout
          errors.add(:checkin, "This time is not available.")
          break
        end
      end
    end
  end

  def in_before_out
    if self.checkin && self.checkout
      if self.checkin > self.checkout
         errors.add(:guest, "Cannot checkout before checking in.")
      end
    end
  end

  def duration_zero
    if self.checkin && self.checkout
      if self.checkin == self.checkout
        errors.add(:guest, "Cannot stay less than one night.")
      end
    end
  end

end
