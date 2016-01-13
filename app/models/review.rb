# == Schema Information
#
# Table name: reviews
#
#  id             :integer          not null, primary key
#  description    :text
#  rating         :integer
#  guest_id       :integer
#  reservation_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  
end
