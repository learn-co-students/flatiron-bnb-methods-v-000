class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description
  validate :associated_res_and_checked_out

  private
    def associated_res_and_checked_out
      if !(Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == "accepted" && Reservation.find(reservation_id).checkout < Date.today)
        errors.add(:rating,"Cannot submit rating at this time")
      end
    end
end
