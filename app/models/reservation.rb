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

  def self.booked(query_begin_date, query_end_date)
    where(checkin: query_begin_date..query_end_date) |
    where(checkout: query_begin_date..query)
  end
end
