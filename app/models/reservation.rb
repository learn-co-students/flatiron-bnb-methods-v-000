class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_before_checkout
  validate :not_own_listing
  validate :is_available

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    duration * listing.price
  end

  private

  def is_available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
    #query = "select * from reservations where listing_id = #{self.listing_id} AND '#{self.checkin}' between checkin AND checkout OR '#{self.checkout}' between checkin AND checkout"
    #if Reservation.find_by_sql(query).size > 0
    #  errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
    #end
  end

  def checkin_before_checkout
    if checkout && checkin && checkout <= checkin
      errors.add(:guest_id, "Checkin date must be before checkout date.")
    end
  end

  def not_own_listing
    if guest_id == listing.host_id
      errors.add(:guest_id, "Cannot book own listing.")
    end
  end
end
