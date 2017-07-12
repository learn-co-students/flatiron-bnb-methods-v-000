class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  has_one :listing, through: :reservation
  has_one :host, through: :listing

  validates :rating, :description, :reservation_id, presence: true
  validate :after_checkout

  private

  def after_checkout
    if !self.reservation || self.reservation.status == "pending" || self.reservation.checkout > Date.today
      errors.add(:reservation_id, "reservation must have happened")
    end
  end

end
