class Review < ActiveRecord::Base
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :legit_review?
  #before_create :show

  
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  has_many :listings, through: :reservations

  def legit_review?
    if self.reservation
      if self.reservation.checkout > Date.today || self.reservation.status != "accepted" 
        errors.add(:reservation_id, "Reservation checkout must be in past")
      end
    end
  end
end
