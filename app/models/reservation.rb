class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkout, :presence => true
  validates :checkin, presence: true
  validate :listing_availability
  validate :date_order

  def  duration
    checkout - checkin
  end

  def total_price
    self.listing.price * self.duration
  end
  private

  def  date_order
    if self.checkin && self.checkout
      if self.checkin >= self.checkout
        errors[:base] << "Dates are wrong"
      end
    end
  end

  def listing_availability
    if self.checkin && self.checkout
      if self.listing.reservations.any? {|reserve| self.checkin.between?(reserve.checkin, reserve.checkout)} || self.listing.reservations.any? {|reserve| self.checkout.between?(reserve.checkin, reserve.checkout)}
        self.errors[:base] << "Not Available"
      end
    end
  end
end
