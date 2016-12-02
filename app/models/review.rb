class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description, :reservation_id
  validate :reservation_status

  private

    def reservation_status
      if self.reservation
        if self.reservation.status == "pending" || self.reservation.checkout > Date.today
          self.errors[:base] << "Unable to submit review"
        end
      end
    end

end
