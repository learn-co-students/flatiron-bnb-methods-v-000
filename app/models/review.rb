class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id
  validate :res_not_passed

  def res_not_passed
    if reservation
      if self.reservation.checkout > Date.today || self.reservation.status != 'accepted'
        errors.add(:checkout, "your reservation was not saved. Please try again.")
      end
    end
  end

end
