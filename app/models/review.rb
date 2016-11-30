class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :check_valid_review

  private

  def check_valid_review
    if reservation && Date.today < reservation.checkout
      errors.add(:reservation, "This review is not valid")
    end
  end

end
