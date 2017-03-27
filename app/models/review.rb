class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: 'User'

  validates :rating, :description, presence: true
  validate :reservation_checkout_validations

  def reservation_checkout_validations
    if !reservation || reservation.status != 'accepted' || reservation.checkout > Date.today
      errors.add(:reservation, "is invalid without an associated reservation, if it has not been accepted, or if checkout has not yet happened.")
    end
  end


end
