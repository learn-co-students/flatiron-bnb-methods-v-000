require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_guest_same_user, :availability, :checkin_checkout_days

  def duration
    (checkout - checkin).to_i if !checkout.nil? && !checkin.nil?
  end

  def total_price
    listing.price * duration
  end

  def unavailable? (check_in, check_out) #to check if self.time is unavailable
    self.checkin <= check_out && self.checkout >= check_in
  end

  private
  def host_guest_same_user
    errors[:guest] = "host can't be the guest" if self.listing.host.id == self.guest_id
  end

  def checkin_checkout_days
    if !duration.nil?
      errors[:checkout] = "checkout can't be before checkin" if duration < 0
      errors[:checkin] = "checkin can't be the same day as checkout" if duration == 0
    end
  end

  def availability
    if checkin && checkout
      listing.reservations.each do |reservation|
        if unavailable?(reservation.checkin, reservation.checkout)
          errors[:checkout] = "time not available during the time period"
        end
      end #end of iterating all reservation
    end #end of pre-checking condition
  end #end of availability method

end
