class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: :true
  validates :checkout, presence: :true
  validate :same_date
  validate :same_ids
  validate :checkin_before_checkout
  validate :unavailable_dates

  def same_ids
  	if self.guest_id == self.listing.host_id
      errors.add(:listing, 'cannot book you own listing.')
    end
  end

  def same_date
    if self.checkin == self.checkout
      errors.add(:checkin, 'checkin and checkout cannot be on the same day.')
    end
  end

  def checkin_before_checkout
    if self.checkin && self.checkout && self.checkin > self.checkout
      errors.add(:reservation, 'checkin date cannot be later than checkout date.')
    end
  end


  def unavailable_dates
    if self.checkin && self.checkout && self.listing.reservations.any?{|res|(res.checkin - self.checkout) * (self.checkin - res.checkout) >= 0}
      errors.add(:reservation, 'unavailable dates.')
    end
  end

  def duration
  	self.checkout - self.checkin
  end

  def total_price
  	self.listing.price * self.duration
  end


end
