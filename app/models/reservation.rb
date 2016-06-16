class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_is_not_host, :available, :before_checkout

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    (duration * listing.price.to_f)
  end

  def guest_is_not_host
    if guest == listing.host
      errors.add(:guest_id, "You can't be your own guest")
    end
  end

  def available
    if checkin && checkout
      listing.reservations.each do |res|
        if res.checkin <= checkout && res.checkout >= checkin
          errors.add(:reservation, "Please be sure to check your dates")
        end
      end
    end
  end

  def before_checkout
    if checkin && checkout
      if checkin >= checkout
        errors.add(:reservation, "Sorry your checkin must be before your checkout.")
      end
    end
  end

end
