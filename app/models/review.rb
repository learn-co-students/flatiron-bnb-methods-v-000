class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :val
  def val
    if reservation!=nil and reservation.status=='pending' then errors.add(:reservation, "not accepted") end
    if reservation!=nil and reservation.checkout>Date.today then errors.add(:reservation, "not checked out yet") end
  end
end
