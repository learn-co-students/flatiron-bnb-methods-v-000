class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :same_ids
  validate :correct_dates
  validate :check_availability


  def same_ids
    if self.guest_id == listing.host_id
      errors.add(:reservation, "You cannot reserve your own listing!")
    end
  end

  def correct_dates
    if self.checkin && self.checkout
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Please check your dates! Your check-in time must be earlier than your checkout time.")
      end
    end
  end

  def check_availability
    if !self.checkin.nil? && !self.checkout.nil?
      listing.reservations.each do |res|
        dates = (res.checkin..res.checkout)
        if dates === self.checkin || dates === self.checkout
          errors.add(:guest_id, "these dates are not available")
        end
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end

end
