class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :valid_review?

  private
  def valid_review?
    if !reservation.nil?
      if reservation.status != "accepted" || reservation.checkout > Date.today
        errors.add(:reservation, "Please submit a review once your reservation has passed")
      end
    end
  end

end
