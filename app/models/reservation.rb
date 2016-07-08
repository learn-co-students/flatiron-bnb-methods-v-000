class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :available, :checkin_before_checkout, :not_own_listing

   def duration
     (checkout - checkin).to_i

   end 

   def total_price
      duration*listing.price
  end

  private

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def not_own_listing
    if guest_id == listing.host_id
      errors.add(:guest_id, "can't reserve own listing")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:guest_id, "check-in date can't be on or after check-out date")
    end
  end
end
