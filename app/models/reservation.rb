class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :no_shilling?

  def no_shilling?
    if guest_id == listing.host_id
      errors.add(:guest_id, "cannot be the same user as the reservation’s listing’s host’s ID")
    end
  end

end
