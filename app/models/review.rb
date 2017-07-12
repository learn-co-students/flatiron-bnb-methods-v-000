class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation 
  validate :checkout_happened
  
  private

  def checkout_happened 
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation is still ongoing, cannot leave review.")
    end
  end

end
