class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
  validate :already_done

  def already_done
    unless reservation.nil?
      if reservation.checkout.to_date > Date.today
        errors.add(:reservation, "can't review on future use")
      end
    end
  end
end
