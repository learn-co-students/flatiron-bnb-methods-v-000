class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_and_host_not_the_same, :is_available, :chronological

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration*listing.price
  end

  private

  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own listing")
    end
  end

  def is_available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |res|
      busy = res.checkin..res.checkout
      if busy === checkin || busy === checkout
        errors.add(:guest_id, "Listing not available during requested dates")
      end
    end
  end

  def chronological
    if checkout == nil || checkin == nil || checkout <= checkin
      errors.add(:guest_id, "Check-out has to be after check-in")
    end
  end

end
