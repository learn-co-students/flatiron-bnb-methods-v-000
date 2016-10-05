class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(start_date, end_date)
    # Listing.where(created_at: (start_date..end_date))
    Listing.all
  end

  

end
