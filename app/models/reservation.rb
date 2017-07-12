class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :not_host, :available, :valid_checkin

  def not_host
    if listing.host_id == guest_id
      errors.add(:guest, "You cannot make a reservation on your own listing.")
    end
  end

  def available
    if checkin && checkout
      listing.reservations.each do |r|
        unavailable = (r.checkin .. r.checkout)
        errors.add(:guest_id, "Reservations are unavailable for these dates.") if unavailable.include?(checkin) || unavailable.include?(checkout)
      end
    end
  end

  def valid_checkin
    if checkin && checkout && checkin >= checkout
      errors.add(:guest_id, "Invalid checkin date.")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end
end
