# == Schema Information
#
# Table name: neighborhoods
#
#  id         :integer          not null, primary key
#  name       :string
#  city_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Neighborhood < ActiveRecord::Base
  has_many :listings
end
