class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  
  validates :checkin, :checkout, presence: true
  validate :not_same_as_host
  validate :listing_available
  
  def not_same_as_host
  	if guest_id == listing.host_id
  		errors.add(:guest_id, "can't be the same as host")
  	end
  end

  def listing_available
  	if !listing.open_during?(checkin..checkout)
  		errors.add(:checkin, "not available")
  		errors.add(:checkout, "not available")
  	end
  end

end
