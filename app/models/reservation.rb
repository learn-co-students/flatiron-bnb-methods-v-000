class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout

  validate :available, :guest_not_host

  private

  def available
    binding.pry
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      binding.pry
    end
  end

  def guest_not_host
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own place.")
    end
  end

end
