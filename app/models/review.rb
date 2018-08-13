class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation
  validate :reservation_was_fulfilled

  extend ArelTables
  include ArelTables

  private

  def reservation_was_fulfilled
    if reservation.present?
      errors.add(:reservation, "reservation hasn't been accepted yet.") unless reservation.status == "accepted"
      errors.add(:reservation, "reservation hasn't ended yet.") if Date.today < reservation.checkout && !errors[:reservation].include?("reservation hasn't been accepted yet.")
    end
  end

end