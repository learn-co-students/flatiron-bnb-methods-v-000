class Review < ActiveRecord::Base
belongs_to :guest, :class_name => "User"
belongs_to :reservation

validates_presence_of :rating, :description, :reservation


validate :reservation_exists_and_accepted_hasnt_happened_yet

  private
  #You can't write a review on a reservation that doesn't exist
  def reservation_exists_and_accepted_hasnt_happened_yet
    errors.add(:reservation_id, "doesn't exist") unless Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == "accepted" && Reservation.find(reservation_id).checkout < Date.today
  end

end
