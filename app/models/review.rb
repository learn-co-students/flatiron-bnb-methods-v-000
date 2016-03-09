class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :reserve

  def reserve
    unless reservation && reservation.status == "accepted" && Date.today > reservation.checkout
      errors.add(:description, "leave now")
    end
  end
end
