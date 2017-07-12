class Review < ActiveRecord::Base
  belongs_to :reservation
  has_one :host, through: :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  validate :reservation_accpeted_and_after_checkout

  def reservation_accpeted_and_after_checkout
    unless reservation && self.reservation.status == 'accepted' && reservation.checkout < Time.now
      errors.add(:reservation_accpeted_and_after_checkout, 'reservation must be accepted and must be after checkout!')
    end
  end
end
