class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true
  validate :reservation_is_in_the_past

  private

  def reservation_is_in_the_past
    return unless errors.empty? 
    if self.reservation.checkout >= Date.today
      errors.add(:reservation, "must have already happened")
    end
  end
end
