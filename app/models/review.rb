class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :super_validate



  def super_validate

    if reservation_id.nil?
      errors[:reservation] = "It looks like you don't have a valid reservation."
    elsif reservation_id
      checkout = Reservation.find_by_id(reservation_id).checkout
      if checkout > Time.now
        errors[:rating] = "You haven't checked out yet."
      elsif Reservation.find_by_id(reservation_id).status != "accepted"
        errors[:reservation] = "It looks like you don't have a valid reservation"
      end
    end
  end
end
