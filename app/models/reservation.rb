class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_host

  private
  def not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own listing.")
    end
  end

end
