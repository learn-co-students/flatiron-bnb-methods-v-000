class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :invalid_same_checkout_checkin
  
  def invalid_same_checkout_checkin
    checkin.to_s != checkout.to_s
  end 
  
end
