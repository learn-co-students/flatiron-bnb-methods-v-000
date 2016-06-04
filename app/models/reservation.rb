class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :guest_is_not_host, :checkout_after_checkin, :available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private
    def guest_is_not_host
      if listing.host.id == guest_id
        errors.add(:guest_id, "Unable to book your own listing!")
      end
    end

    def checkout_after_checkin
      if checkout && checkin && checkout <= checkin
        errors.add(:guest_id, "Checkout time is before checkin")
      end
    end

    def available
      Reservation.where(listing_id: listing_id).where.not(id: id).each do |res|
        dates_taken = res.checkin..res.checkout
        if dates_taken === checkin || dates_taken === checkout
          errors.add(:guest_id, "This listing is not available during those dates")
        end
      end
    end

end
