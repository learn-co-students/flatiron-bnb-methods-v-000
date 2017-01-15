class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :check_host_guest
  validate :valid_checkin
  validate :checkin_before_checkout

  # Not sure how to validate that host and guest arent the same

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    (self.listing.price.to_f) * self.duration
  end


  private

  def check_host_guest
    errors.add(:guest, "can't be same as host") if self.listing.host == self.guest
  end

  def valid_checkin
  reservations = []
  
  if checkin && checkout
    self.listing.reservations.each do |reservation|
      if reservation.checkout > self.checkin && reservation.checkin < self.checkout
        reservations << reservation
      end
    end
  end
  errors.add(:unavailable, "checkin not available") if !reservations.empty?
end

  def checkin_before_checkout
    if checkin && checkout
      errors.add(:checkin, "check in must be before checkout") if self.checkin > self.checkout
      errors.add(:checkin, "both dates are the same") if self.checkin == self.checkout
    end
  end


end
