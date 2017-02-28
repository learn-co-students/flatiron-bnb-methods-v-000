class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: 'User'
  validates_presence_of :rating, :description
  validate :checkout

  private

  def checkout
    if !reservation || (reservation.status != 'accepted') || (reservation.checkout > Date.today)
      errors.add(:reservation, 'is invalid without an associated reservation, has been accepted, and checkout has happened')
    end
  end
end
