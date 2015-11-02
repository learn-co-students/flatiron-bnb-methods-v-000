# == Schema Information
#
# Table name: reservations
#
#  id         :integer          not null, primary key
#  checkin    :date
#  checkout   :date
#  listing_id :integer
#  guest_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  status     :string           default("pending")
#

class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
end
