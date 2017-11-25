class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  
  validates_presence_of :rating, :description, :reservation_id
  validate :invalid_review

  def status
    if reservation
      self.reservation.status.downcase.include?("accepted") && self.reservation.checkout.to_date <= Date.today
    end
  end

  def invalid_review
    errors.add(:base, "Your review is invalid") if !status
  end

end
