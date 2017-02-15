class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  belongs_to :host, :class_name => "User"
  # belongs_to :host, :through => :reservations
  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation_id, presence: true
  validate :reservation_already_happened

    def reservation_already_happened
        if self.reservation_id
            if self.reservation.checkout > Date.today
                  errors.add(:rating, "Reservation must be in the past")
           end
       end
    end

end
