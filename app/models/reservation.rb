class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :is_not_own_listing, :checkout_is_later_than_checkin, :is_available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end

  private
  def is_not_own_listing
    if guest_id == listing.host_id
      errors.add(:guest, "Sorry: you can't book your own listing")
    end
  end

  def is_available # makes sure that listing is available during checkin, checkout dates
    Reservation.where(listing_id: listing).where.not(id: id).each do |res|
      if (checkin && checkout) && (res.checkin..res.checkout === (checkin..checkout)) # (checkin && checkout) verifies presence of both; needed to pass master spec
        errors.add(:guest, "Sorry: this listing is not available for your desired dates")
      end
    end
  end

  def checkout_is_later_than_checkin
    if (checkout && checkin) && (checkout <= checkin)
      errors.add(:checkout, "Sorry: checkout date needs to be later than checkin date")
    end
  end
end

## Passes master and solution branch specs
