class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  has_many :reviews

  # For a user to check if listing is available during provided dates
  def available?(start_date, end_date)
    if self.reservations.
  end

end
