class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :same_date
  validate :same_ids
  validate :checkin_before_checkout
  validate :unavailable_dates



  def same_date
    errors.add(:checkin, 'checkin and checkout cannot be on the same day.') if self.checkin == self.checkout
  end

  def same_ids
    errors.add(:listing, 'cannont book your own listing.') if self.guest_id == self.listing.host_id
  end

  def checkin_before_checkout
    errors.add(:Reservation, 'checkin date cannot be later than checkout date.') if self.checkin && self.checkout && self.checkin > self.checkout
  end

  def unavailable_dates
    errors.add(:reservation, 'unavailable dates.') if self.checkin && self.checkout && self.listing.reservations.any?{|res|(res.checkin - self.checkout) * (self.checkin - res.checkout) >= 0}
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * self.duration
  end



end
