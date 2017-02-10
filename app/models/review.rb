class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, presence: true
  validate :associated_reservation

  private

  def associated_reservation
    if self.reservation_id ==  nil
      errors.add(:reservation_id, "Has to be associated with reservation")
    end
  end
end
