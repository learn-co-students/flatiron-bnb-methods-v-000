class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :not_same_as_host, :check_dates, :check_availability

  def not_same_as_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, 'cannot be the same as host.')
    end
  end

  def check_dates
    unless !self.checkin || !self.checkout
      if self.checkin >= self.checkout
        errors.add(:guest_id, 'Invalid checkin date')
      end
    end
  end

  def check_availability
    self.listing.reservations.each do |reservation|
      dates = reservation.checkin..reservation.checkout
      if dates === self.checkin || dates === self.checkout
        errors.add(:guest_id, 'No availability for these dates.')
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
