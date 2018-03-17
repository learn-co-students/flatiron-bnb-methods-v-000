class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  validate :checker

  private

    def checker
      if !reservation || reservation.status != 'accepted' || reservation.checkout > Date.today
        errors.add(:checker, "Review is Invalid")
      end
    end

end
