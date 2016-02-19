class ReviewValidator < ActiveModel::Validator
  def validate(record)
    #binding.pry
    if record.reservation.nil?
      record.errors[:reservation] << "This review needs an associated reservation"
    elsif record.reservation.checkout > Date.today
      record.errors[:reservation] << "Reviews can only be completed after check-out"
    end
  end
end

class Review < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validates_with ReviewValidator
end
