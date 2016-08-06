class Review < ActiveRecord::Base
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  #validates_associated :reservation
  validate :legit_review?
  
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  has_many :listings, through: :reservations

  def legit_review?
    if self.reservation && self.reservation.checkout <= Date.today  && self.reservation.status == "accepted"
      true
    end
  end
end
