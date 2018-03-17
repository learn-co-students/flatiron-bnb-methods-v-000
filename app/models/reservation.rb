require 'pry'
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :host_cannot_reserve_own
  validate :if_available
  validate :correct_dates

  def duration
    (checkout.day - checkin.day)
  end

  def total_price
    self.duration * self.listing.price
  end

  private
    def host_cannot_reserve_own
      if self.guest == self.listing.host
        errors.add(:guest, "cannot be the host.")
      end
    end

    def if_available
      flag = true
      self.listing.reservations.each do |r|
        r_range = r.checkin..r.checkout
        if r_range.include?(self.checkin) || r_range.include?(self.checkout)
          flag = false
        end
      end
      
      if flag == false
        errors.add(:guest_id, "Sorry it's already booked")
      end
    end

    def correct_dates
      if self.checkin && self.checkout
        if self.checkin > self.checkout || self.checkin == self.checkout
          errors.add(:guest_id, "You booked an invalid reservation")
        end
      end
    end
end
