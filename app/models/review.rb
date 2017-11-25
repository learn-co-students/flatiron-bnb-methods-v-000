class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description

  validate :valid_res, :res_status


  private
  #res status = accepted, res.id is valid, checkout date has occured
  def valid_res
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Invalid reservation and/or checkout.")
    end
  end

  def res_status
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Status is not accepted")
    end
  end
end
