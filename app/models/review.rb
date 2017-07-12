class Review < ActiveRecord::Base

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"


  validates :reservation, :description, presence: true
  validates :rating, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5,
    only_integer:true
  }
  validate :acceptance, :checkout

  def acceptance
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation needed")
    end
  end

  def checkout
    if reservation &&
      Date.today < reservation.checkout
      errors.add(:reservation, "Reservation needs to complete")
    end
  end


end
