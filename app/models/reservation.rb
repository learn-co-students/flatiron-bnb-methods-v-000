class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :self_host, :check_dates, :check_availability

  def self_host
    if guest_id == listing.host_id
      errors.add(:guest_id, 'cannot be the same as host.')
    end
  end
  def check_dates
    unless !checkin || !checkout
      if checkin >= checkout
        errors.add(:guest_id, 'Checkin date not valid.')
      end
    end
  end
  def check_availability
    listing.reservations.each do |reservation|
      dates = reservation.checkin..reservation.checkout
      if dates === self.checkin || dates === self.checkout
        errors.add(:guest_id, 'Dates unavailable.')
      end
    end
  end
  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

end
