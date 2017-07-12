class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :host_is_not_guest, :available_at_checkin?, :available_at_checkout?, :checkin_comes_before_checkout?

  def host_is_not_guest
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "sorry, you can't reserve a listing that belongs to you.")
    end
  end

  def available_at_checkin?
    if !self.listing.reservations.empty?
      self.listing.reservations.each do |res|
        if res.id != self.id && (res.checkin..res.checkout) === self.checkin
          errors.add(:guest_id, "sorry, this reservation is not valid for the selected dates")
        end
      end
    end
  end

  def available_at_checkout?
    if !listing.reservations.empty?
      listing.reservations.each do |res|
        if res.id != id && (res.checkin..res.checkout) === checkout
          errors.add(:guest_id, "sorry, this reservation is not valid for the selected dates")
        end
      end
    end
  end

  def checkin_comes_before_checkout?
    if checkin && checkout
      if checkout <= checkin
        errors.add(:guest_id, "sorry, you must checkout not sooner than 1 day after checkin")
      end
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end
end
