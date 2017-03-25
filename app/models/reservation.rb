class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validates :checkin, :checkout, uniqueness: true

  validates_associated :listing, absence: true

end
