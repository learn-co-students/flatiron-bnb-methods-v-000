class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :not_own_listing
  validate :dates_available
  validate :checkin_before_checkout

  # instance methods
  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end

  # Class methods

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
    return false if dates_nil?
    list_of_upcoming_res = self.listing.reservations.select do |res|
      res.checkout >= self.checkin unless res.checkin >= self.checkout
    end
    conflicting_res = list_of_upcoming_res.select do |res|
      res.checkin < self.checkout
    end
    return true if conflicting_res.empty?
    return false
  end

  def checkin_before_checkout
    if !dates_nil?
      if self.checkin >= self.checkout
        errors.add(:dates, "are not chronological")
      end
    end
  end

  # helper methods
  def dates_nil?
    return true if self.checkin == nil || self.checkout == nil
    return false
  end

end
