class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :not_own_listing
  validate :dates_available


  private

  def not_own_listing
    if self.guest == self.listing.host
      errors.add(:guest, "can't reserve own listing")
    end
  end

  def dates_available
    if !available?
      errors.add(:dates, "are not available")
    end
  end

  def available?
    # select all reservations with checkin dates on or after the desired checkin date. Make sure the checkin date is then on or after the desired checkout date.
    return false if self.checkin == nil || self.checkout == nil
    list_of_upcoming_res = self.listing.reservations.select do |res|
      res.checkout >= self.checkin unless res.checkin >= self.checkout
    end
    conflicting_res = list_of_upcoming_res.select do |res|
      res.checkin < self.checkout
    end
    return true if conflicting_res.empty?
    return false
  end

end
