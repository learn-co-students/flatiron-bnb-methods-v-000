class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  
  validate :host_cannot_be_guest, :listing_available

  private

  def host_cannot_be_guest
    if guest == listing.host
      errors.add(:guest_id, "can't be the host")
    end
  end

  def listing_available
    if checkin && checkout && (checkin_changed? || checkout_changed?) && !listing.available?(checkin, checkout)
      errors.add(:guest_id, "dates unavailable")
    end
  end
end
