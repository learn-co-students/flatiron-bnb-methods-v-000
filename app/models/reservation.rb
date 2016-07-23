class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin
  validates_presence_of :checkout
  validate :no_res_for_host
  

  private

  def no_res_for_host
    if self.guest_id == listing.host_id
      errors.add(:guest, "cannot make reservation on own listing")
    end
  end

  

end
