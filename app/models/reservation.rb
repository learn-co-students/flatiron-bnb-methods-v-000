class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_many :hosts, class_name: "User", through: :listing
  has_many :host_reviews, class_name: "Review"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :cant_make_reservation_on_own_listing
  validate :booking_conflict
  validate :checkout_checkin_conflict



  def duration
  	(checkout - checkin).floor
  end

  def total_price
    listing.price * duration
  end

  def day_lister
    days = *0..duration
    days.collect { |d| checkin + d }
  end

  private

  def booking_conflict
  	if !listing.nil?
      listing.reservations.detect do |l|
        if l.day_lister & [checkin, checkout]).any?
          errors.add(:booking_conflict, "There is already a booking at that time")
        end
      end
  	end
  end

 
  def checkout_checkin_conflict
    if !checkin.nil? && !checkout.nil? && checkin >= checkout
      errors.add(:checkout_conflict, "You can't book checkin on or after checkout date")
    end
  end


  def cant_make_reservation_on_own_listing
  	if guest_id == listing.host_id
  		errors.add(:duplicate, "You can't make a reservation on your own listing")
  	end
  end

end
