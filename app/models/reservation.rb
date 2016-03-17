require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_same_id
  validate :available
  validate :checkin_before_checkout


  def not_same_id
    if self.guest_id == listing.host_id
      errors.add(:not_same_id, "you cannot make a reservation on your own listing")
    end
  end


  def available
    self.listing.reservations.each do |reservation|
      reservation_dates = reservation.checkin..reservation.checkout
      if reservation_dates.include?(self.checkin) || reservation_dates.include?(self.checkout)
        errors.add(:available, "Sorry, these dates are already booked.")
      end
    end
  end

  def checkin_before_checkout
    if self.checkin && self.checkout
      if self.checkout <= self.checkin
        errors.add(:checkin_before_checkout, "your checkin and checkout dates don't make sense")
      end 
    end
  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.duration * self.listing.price
  end







end   