class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :cannot_reserve_own_listing, :confirm_availability, :valid_checkin_time

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  protected

  def cannot_reserve_own_listing
    if guest_id == listing.host_id
      errors.add(:guest_id, "You cannot reserve a room that you listed.")
    end
  end

  def confirm_availability
    res_dates = [checkin, checkout]

    self.listing.reservations.each do |res|
      res_dates.each do |date|
        if (res.checkin..res.checkout).include?(date)
          errors.add(:guest_id, "Sorry, those dates are already reserved.")
        end
      end
    end
  end

  def valid_checkin_time
    if checkin && checkout
      if checkin > checkout || checkin == checkout
        errors.add(:guest_id, "checkout time can't precede the checkin time.")
      end
    end
  end
end
