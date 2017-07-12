class Reservation < ActiveRecord::Base
  belongs_to :listing
  has_one :host, through: :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, presence: true
  validates :checkout, presence: true
  validates :listing_id, presence: true
  validates :guest_id, presence: true
  validate :guest_is_not_host, :valid_range
  validate :availability, unless: :persisted?

  before_create :status_accepted

  def duration
   start_date = checkin
   end_date = checkout
   (start_date...end_date).count
  end

  def total_price
    duration * listing.price
  end

  def self.booked(start_date, end_date)
    where(checkin: start_date..end_date) || where(checkout: start_date..end_date) || where("checkin < ? AND checkout > ?", start_date, end_date)
  end

  def self.booked_listings(start_date, end_date)
    self.booked(start_date, end_date).map {|b| b.listing}
  end


 private

 def guest_is_not_host
   if host && guest && guest.id == host.id
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
   #listing.reservations.each do |r|
    # if (r.checkin < checkout && r.checkin > checkin) || (r.checkout > checkin  && r.checkout < checkout)
    #   if !Listing.available?
    if !listing.available?(checkin, checkout)
      errors.add(:listing, "This listing is not available for those dates")
    end
   end
 end

end
