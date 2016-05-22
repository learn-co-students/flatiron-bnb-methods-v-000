class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: :true
  validate :not_same_host_and_guest, :available, :checkin_before_checkout

  def not_same_host_and_guest
    if guest_id == listing.host_id
      errors.add(:guest_id, "You cannot reserve your own apartment.")
    end
  end

  def available
    listing.reservations.where.not(id: id).each do |reservation|
      reservation_date_range = reservation.checkin..reservation.checkout
      if reservation_date_range === checkin || reservation_date_range === checkout
        errors.add(:guest_id, "Not available during the requested dates.")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

end
