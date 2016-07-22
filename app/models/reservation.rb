class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :own_listing?, :available?, :checkout_after_checkin?

  def own_listing?
    errors.add(:listing, 'Cannot make reservation on own listing') unless self.listing.host != self.guest
  end

  def available?
    self.class.where(:listing_id => listing.id).where.not(:id => id).each do |reservation|
      reserved_dates = reservation.checkin..reservation.checkout
      if reserved_dates === self.checkin || reserved_dates === self.checkout
        errors.add(:listing, 'Could not book due to date conflict')
      end
    end
  end

  def checkout_after_checkin?
    errors.add(:guest_id, 'Cannot check out before checking in') unless self.checkin && self.checkout && self.checkin < self.checkout
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end
end
