class Reservation < ActiveRecord::Base
  require 'date'

  belongs_to :listing
  belongs_to :guest, class_name: 'User'
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_not_guest, :available?, :valid_times

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def host_not_guest
    if guest == listing.host
      errors.add(:host_not_guest, 'You are not able to reserve your own listing.')
    end
  end

  def available?
    listing.reservations.each do |reservation|
      reservation_dates = reservation.checkin..reservation.checkout
      if reservation_dates.include?(checkin) || reservation_dates.include?(checkout)
        errors.add(:available?, 'Chosen dates are not available')
      end
    end
  end

  def valid_times
    if checkin && checkout
      if checkin >= checkout
        errors.add(:guest_id, 'Checkin date must be before checkout.')
      end
    end
  end


end
