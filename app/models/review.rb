class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :legitimacy


  def legitimacy
    if reservation.present?
      status = reservation.status
      # binding.pry
      unless status == 'accepted' && reservation.checkout < Date.today
        errors.add(:self, 'is not a legitimate review')
      end
    else
      errors.add(:reservation, 'was non-existant')
    end
  end
end
