class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :cannot_reserve_own_listing, :available_at_checkin, :checked_in?

  def duration
    self.checkout - self.checkin
  end

  def total_price
    duration * self.listing.price
  end

  def cannot_reserve_own_listing
    if self.guest_id == self.listing.host.id
      errors.add(:listing, "cannot reserve own listing")
    end
  end

  def available_at_checkin
    self.listing.reservations.each do |r|
      range = (r.checkin..r.checkout)
      if range.include?(checkin) || range.include?(checkout)
        errors.add(:guest_id, "not available")
      end
    end
  end

  def checked_in?
    if self.checkin && self.checkout && self.checkin >= self.checkout
      errors.add(:checkin, "you're not checked in")
    end
  end
end
