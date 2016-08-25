class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  validate :must_not_reserve_own_listing

  def must_not_reserve_own_listing
    if self.listing && self.listing.host && self.guest
      # if self.listing.host_id != self.guest_id
      #   errors.add(:listing, "must not reserve your own listing")
      # end
    end
  end

end
