class Neighborhood < ActiveRecord::Base
  include Ratio::InstanceMethods
  extend Ratio::ClassMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(start_date, end_date)
    self.listings.each do |listing|
      listing.reservations.where(":checkin >= ? AND :checkout <= ? AND :status != ?", start_date, end_date, "accepted")
    end
  end


end
