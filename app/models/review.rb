class Review < ActiveRecord::Base

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true

  #before_validation :check_reservation

  def check_reservation
      unless self.reservation.present? && self.reservation.status == 'accepted' && self.reservation.checkout < Date.today
          self.errors[:reservation] << 'associated reservation invalid'
      end
  end

end
