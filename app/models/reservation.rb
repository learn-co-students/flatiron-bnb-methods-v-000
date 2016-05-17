class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_is_not_the_host, :available, :one_day_minimum_stay

  def duration
    if checkin && checkout
      (checkout - checkin).to_i
    end
  end

  def total_price
    if duration
      self.listing.price*duration
    end
  end

  private

  def guest_is_not_the_host
    if guest_id == self.listing.host.id
      errors.add(:guest, "cannot stay at your own listing")
    end
  end

  def available
    rezes = Reservation.where(listing_id: listing_id)
    if checkin && checkout
      rezes.each do |rez|
        if id == rez.id
          break
        elsif checkin.between?(rez.checkin, rez.checkout)
          errors.add(:checkin, "selected listing is unavailable at requested time")
        elsif checkout.between?(rez.checkin, rez.checkout)
          errors.add(:checkout, "selected listing is unavailable at requested time")
        else
          #do nothing
        end
      end
    end
  end

  def one_day_minimum_stay
    if duration && duration <= 0
      errors.add(:checkout, "There is a 1 day minimum stay.")
    end
  end
end
