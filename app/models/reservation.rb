class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :guest_id, is_not_host: true 
  validates_presence_of :checkin, :checkout
  validates :checkin, before_checkout: true
  validates_with AvailabilityValidator, on: :create

  def accepted?
    status == "accepted"
  end

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end
end
