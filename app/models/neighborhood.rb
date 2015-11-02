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
  belongs_to :city
  has_many :listings


  def available_listings_from(begin_date, end_date)
    listings.listings_available_from(begin_date, end_date)
  end
end
