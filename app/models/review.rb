class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true

  validate :good

  private
  def good
    if self.reservation.nil? || self.reservation.status != "accepted" || self.reservation.checkout > Date.today
      errors.add(:reservation, "no good!")
    end
  end

end
