class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :same_day
  validate :checkin_before_checkout
  validate :same_person
  validate :available

  def same_day
    if checkin == checkout
      errors.add(:reservation, "Please check your dates.")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkout < checkin
      errors.add(:reservation, "Checkout date must be after checkin date.")
    end
  end

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  def same_person
    if guest_id == listing.host_id
      errors.add(:reservation, "You cannot reserve your own property.")
    end
  end

  def available
    if checkin != nil || checkout != nil
     errors.add(:reservation, "This listing is already reserved.")
    end
  end

end
