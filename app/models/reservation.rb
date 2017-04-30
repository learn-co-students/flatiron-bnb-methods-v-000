class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_cannot_be_host, :available, :valid_checkin

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private

  def guest_cannot_be_host
  	if guest_id == listing.host_id
  		errors.add(:host, "Guest and host cannot be the same")
  	end
  end

  def available
    if checkin && checkout
      if !listing.is_available?(checkin, checkout)
        errors.add(:checkin, "Checkin date not valid")
      end
    end
  end

  def valid_checkin
    if checkin && checkout
      if checkin >= checkout
        errors.add(:checkin, "Checkin date must be prior to checkout")
      end
    end
  end

end
