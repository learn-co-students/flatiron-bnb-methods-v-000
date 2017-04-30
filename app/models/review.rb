class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true
  validate :valid_review?

  def valid_review?
    if reservation.nil? || reservation.status != 'accepted'
      errors.add(:reservation, 'is invalid')
      return
    end
    
    if Date.today < reservation.checkout
      errors.add(:reservation, 'must be in the past')
    end
  
  end
  

end
