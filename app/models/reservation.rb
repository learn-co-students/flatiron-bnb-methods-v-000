class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout
  validate :listing_availability, :date_order, :not_your_house

  def duration
    checkout - checkin
  end

  def total_price
    self.listing.price * self.duration
  end

  private
  def not_your_house
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def date_order
    if self.checkin && self.checkout
      if self.checkin >= self.checkout
        errors.add(:guest_id, "You live here")
      end
    end
  end

  def listing_availability
    self.listing.reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest_id, "Already Booked")
      end
    end
  end
end