class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validates :checkin, :checkout, uniqueness: true

  validates_associated :listing, absence: true
  validate :check_checkin_and_checkout, :checkin_before_checkout


  before_create :check_availablity

  def check_availablity
    #  binding.pry
    #  listing.all.each
    if status != "accepted"
      errors.add(:status, "This listing is not available for the dates you've chosen")
    end
  end

  def check_checkin_and_checkout
    errors.add(:checkout, "can't be the same as checkin date") if checkin == checkout

  end

  def duration
    (checkin..checkout).count-1
  end

  def total_price
    (listing.price).to_f * duration
  end

  def checkin_before_checkout
    errors.add(:checkin, "checkin date must be before checkout date") if checkout && checkin && checkout < checkin
  end

end
