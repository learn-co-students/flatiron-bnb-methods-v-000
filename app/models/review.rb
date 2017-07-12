class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :premature?

  def premature?
    if reservation
      if reservation.checkin && reservation.checkout
        if reservation.checkout.to_date > Date.today
          errors.add(:rating, "cannot be left before checkout.")
        end
      end
    end
  end

end
