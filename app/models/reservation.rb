class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :checkin_before_checkout, :own_listing, :available_checkin_checkout


  def available_checkin_checkout
    if checkin && checkout
      listing.reservations.each do |rez|
        if (rez.checkin <= checkout) && (rez.checkout > checkin)
          errors.add(:checkin, "invalid date range, listing is occupied")
        end
      end
    end

  end

  def checkin_before_checkout
    if (checkin && checkout) && checkin >= checkout
      errors.add(:checkin, "cannot be after checkout")
    end
  end

  def own_listing
    if listing.host == guest
      errors.add(:listing, "cannot make reservation on your own listing")
    end
  end

  def total_price
    duration * listing.price
  end

  def duration
    (checkout - checkin).to_i
  end

end
