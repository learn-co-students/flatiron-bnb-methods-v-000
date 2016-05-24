class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review
  #validates :user, uniqueness: {scope: :host, :guest}
  #validates :checkin 

end
