require_relative 'review_validity.rb'

class Review < ActiveRecord::Base
  include ActiveModel::Validations
  #ReviewValidity

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  
  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true
  #validates :checkout, presence: true

  #validates_with ReviewValidity
  validate :valid_review

  def valid_review
    #binding.pry
    reservation = Reservation.find_by(id: self.reservation_id)
    
    if reservation
      unless reservation.status != "accepted" || reservation.checkout > Time.now
        self.errors[:checkout] << 'No review possible without checkout'
      end
    end

  end
end
