class Reservation < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true


  validates_with ValidateRes
  validates_with ValidateCheckin
  validates_with CheckinBefore
  validates_with CheckinSame
  validates_with CheckoutAvailable
  
  def duration
  	self.checkout - self.checkin
  end
  
  def total_price
  	self.listing.price * self.duration
  end
  
end
