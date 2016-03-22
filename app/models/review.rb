class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validates_presence_of :reservation
  validate :checked_out

  private
    def checked_out
      if self.reservation && self.created_at && self.reservation.checkout >= self.created_at
        errors.add(:review, "Must be checked out to write reviews.")
      end
    end
end
