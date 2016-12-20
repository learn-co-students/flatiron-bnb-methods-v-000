class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  validate :check_validity

  private

    def check_validity
      if !reservation || reservation.status != 'accepted' || reservation.checkout > Date.today
        errors.add(:check_validity, "Review is Invalid")
      end
    end

end
