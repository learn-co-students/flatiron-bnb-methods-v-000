require 'pry'
class Review < ActiveRecord::Base
  validates :rating, presence: true
  validates :description, presence: true
  validate :approved_reservation  

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def approved_reservation
    if self.reservation_id.nil? 
      errors[:reservation] << "Cannot make a review because there's no reservation"
    else
      errors[:reservation] << "Cannot make a review because reservation was not accepted" if self.reservation.status != "accepted"
      errors[:reservation] << "Cannot make a review until checkout occurs" if self.reservation.checkout > Time.now
    end
  end

end
