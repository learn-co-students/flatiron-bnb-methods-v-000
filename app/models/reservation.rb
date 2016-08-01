class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validate :checkin_on_or_after_checkout, :no_res_on_own_listing, :available
  validates :checkin, :checkout, presence: true

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    duration * self.listing.price.to_f
  end

  private

  def checkin_on_or_after_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:checkin, "can't be after checkout date")
    end
  end

  def no_res_on_own_listing
    if guest_id == listing.host_id
      errors.add(:guest_id, "can't make reservation on own listing")
    end
  end

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

end
