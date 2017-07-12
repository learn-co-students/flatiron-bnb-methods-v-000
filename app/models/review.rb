class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true

  validate :confirm

  def confirm
    if self.reservation && self.reservation.checkout <= Date.today
      true
    else
      errors.add(:description, "Can't write Review!")
    end
  end

end
