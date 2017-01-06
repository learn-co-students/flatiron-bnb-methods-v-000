class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :invalid_same_ids
  validate :same_checkout
  validate :overlap

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price.to_f * self.duration
  end

  private

  def invalid_same_ids
    if self.guest_id == self.listing_id
      errors.add(:guest_id, "cannot reserve your own listing")
    end
  end

  def overlap
    self.listing.reservations.each do |reservation|
      if self.checkin.nil? || self.checkout.nil? || ((self.checkin - reservation.checkout) * (reservation.checkin - self.checkout)) >= 0
        errors.add(:checkin, "invalid reservation")
      end
    end
  end

 def same_checkout
   if !self.checkin.nil? && !self.checkout.nil? && self.checkout <= self.checkin
     errors.add(:checkin, "checkin cannot be the same as checkout")
   end
 end

end
