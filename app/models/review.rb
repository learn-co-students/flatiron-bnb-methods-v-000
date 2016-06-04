class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :description, :rating, :reservation

  validate :res_passed

  private
    def res_passed
      if reservation && reservation.checkout > Date.today
        errors.add(:reservation, "The reservation has not ended yet!")
      end
    end
end
