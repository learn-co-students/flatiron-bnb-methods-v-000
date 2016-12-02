class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :guest_and_host_not_the_same, :check_availablity, :check_dates

  def guest_and_host_not_the_same
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def check_availablity
    self.listing.reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def check_dates
    unless !self.checkin || !self.checkout
      if self.checkin >= self.checkout
        errors.add(:guest_id, "Your check-in date is invalid")
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * duration
  end

end
