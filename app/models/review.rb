class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates_presence_of :rating, :description, :reservation
  validate :new_review, :already_checkout?
   
  def new_review
   if rating && description && reservation
    errors.add(:reservation, "There is no reservation to review") unless reservation.status == "accepted"
     end
   end
   
   def already_checkout?
    if rating && description && reservation
      errors.add(:reservation, "The reservation has to checked ot first") unless reservation.checkout.past? 
    end
  end
end
