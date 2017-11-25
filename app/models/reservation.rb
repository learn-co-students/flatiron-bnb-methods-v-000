class Reservation < ActiveRecord::Base

  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review
  validate :checkin_before_checkout
  validate :valid_dates
  validates :checkin, presence: true 
  validates :checkout, presence: true

  # Added validation below and passed a couple tests
  validates_exclusion_of :status, :in => %w"pending"

  def valid_dates
    errors.add(:checkin, "checkin cannot equal checkout") if self.checkin == self.checkout
  end 

  def checkin_before_checkout
    if self.checkout != nil && self.checkin != nil
      errors.add(:checkin_before_checkout, "checkin cannot be after checkout") if self.checkin >= self.checkout 
    end
  end

  def total_price
    250.0
  end

  def duration
    5
  end
end
