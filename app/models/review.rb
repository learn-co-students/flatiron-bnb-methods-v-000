class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  
  ### Validations ### 
  
  # Custom Validator for associated reservation #
  
  class ResValidator < ActiveModel::Validator 
    def validate(record)
      if record.reservation && record.reservation.valid? 
        if Date.today < record.reservation.checkout
          record.errors[:reservation] << "Review cannot be made before checkout has happened"
        end
      else
        record.errors[:reservation] << "Reviews must belong to a valid reservation"
      end
    end
  end
  
  validates :rating, presence: true 
  validates :description, presence: true
  validates_with ResValidator

end
