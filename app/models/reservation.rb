class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :same?, :availability, :checkin_first?

  def duration
   checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def same?
     if guest_id == listing.host_id
       errors.add(:guest_id, "Guest and Host cannot be the same.")
     end
  end

  def availability
    if checkin && checkout
      listing.reservations.each do |r|
        unavailable = (r.checkin .. r.checkout)
        errors.add(:guest_id, "Unavailable.") if unavailable.include?(checkin) || unavailable.include?(checkout)
      end
    end
  end

  def checkin_first?
     if checkin && checkout && checkin >= checkout
         errors.add(:guest_id, "Must Check in before you check out")
     end
   end

end
