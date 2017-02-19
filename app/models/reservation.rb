class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true

  validate :not_the_host, :available?, :checkin_before_checkout?


  def not_the_host
    if guest_id == listing.host_id
      errors.add(:guest_id, "Booking your own apt.")
    end
  end

  def available?
    listing.booked.each do |booked|
      # binding.pry
      if booked.include?(checkin) || booked.include?(checkout)
        errors.add(:guest_id, "Booking your own apt.")
      end
    end
  end

  def checkin_before_checkout?
    binding.pry

    # if checkin < checkout
    #   errors.add(:guest_id, "Great Scott, time traveler, check your booking dates")
    # end
  end



end
