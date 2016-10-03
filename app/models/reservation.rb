class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_own_reservation?

  def not_own_reservation?
    if self.listing.host_id == self.guest_id
      errors.add(:reservation, "Can not reserve your own listing")
    end
  end


end
