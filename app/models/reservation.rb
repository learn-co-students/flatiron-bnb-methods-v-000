class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  validates_presence_of :checkin, :checkout
  validate :guest_is_not_host, :listing_available, :checkin_before_checkout

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  private

    def guest_is_not_host
      if guest_id == listing.host_id
        errors.add(:guest_id, "You cannot book your own listing.")
      end
    end

    def listing_available
      Reservation.where(listing_id: listing_id).where.not(id: id).each do |res|
        dates_reserved = res.checkin..res.checkout
        if dates_reserved === checkin || dates_reserved === checkout
          errors.add(:guest_id, "Sorry, this listing is not available during those dates.")
        end
      end
    end

    def checkin_before_checkout
      if checkin && checkout && checkout <= checkin
        errors.add(:guest_id, "Checking date must be before checkin.")
      end
    end



end
