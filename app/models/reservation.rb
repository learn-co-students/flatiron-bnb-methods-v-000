class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :not_your_own_listing
  validate :does_not_conflict

  def not_your_own_listing
    if guest == listing.host
      errors.add(:guest, "can't reserve your own listing")
    end
  end

  def does_not_conflict
    return if !self.checkin || !self.checkout
    if self.checkin == self.checkout
      errors.add(:checkin, "must stay at least 1 night")
    elsif self.checkin > self.checkout
      errors.add(:checkin, "must be before checkout")
    else
      self.listing.reservations.each do |r|
        if r.checkin.between?(self.checkin, self.checkout) || r.checkout.between?(self.checkin, self.checkout)|| self.checkin.between?(r.checkin, r.checkout) || self.checkout.between?(r.checkin, r.checkout)
          errors.add(:checkin, "dates conflicting")
          break
        end
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end


end
