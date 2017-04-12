class Reservation < ActiveRecord::Base
  belongs_to :listing
  has_one :host, through: :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates_presence_of :checkin, :checkout, :listing_id, :guest_id
  validate :guest_is_not_host, :valid_range, :availability
  before_save :status_accepted

  def duration
   start_date = checkin
   end_date = checkout
   (start_date...end_date).count
  end

  def total_price
    duration * listing.price
  end

  def self.booked(start_date, end_date)
    where(checkin: start_date..end_date) & where(checkout: start_date..end_date)
  end

  def self.booked_listings(start_date, end_date)
    self.booked(start_date, end_date).map {|b| b.listing}
  end




 private

 def guest_is_not_host
   if guest && guest.id == host.id
     errors.add(:guest, "Host cannot be a guest")
   end
 end

 def status_accepted
   status = "accepted"
 end

 def valid_range
   if checkin && checkout && checkin >= checkout
     errors.add(:guest, "Checkin cannot be after checkout")
   end
 end



 def availability
   if checkin && checkout
   listing.reservations.each do |r|
     if (r.checkin < checkout && r.checkin > checkin) || (r.checkout > checkin  && r.checkout < checkout)
       errors.add(:listing, "This listing is not available for those dates")
     end
   end
  end
 end







end
