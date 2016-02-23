class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :reservation_fulfilled

  private

  def reservation_fulfilled
    unless reservation_exists? && reservation_accepted? && checked_out?
      errors.add(:reservation_id, "You must fulfill your reservation to submit a review.")
    end
  end

  def reservation_exists?
    Reservation.exists?(reservation_id)
  end

  def reservation_accepted?
    Reservation.find(reservation_id).status == "accepted"
  end

  def checked_out?
    Date.today >= Reservation.find(reservation_id).checkout
  end
end
