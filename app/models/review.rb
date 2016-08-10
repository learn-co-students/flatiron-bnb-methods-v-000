class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :can_exist?

private

  def can_exist?
    unless self.reservation && self.reservation.status == "accepted" && self.reservation.checkout < DateTime.now
      errors.add(:reservation, "This review is for an invalid reservation.")
    end
  end

end
