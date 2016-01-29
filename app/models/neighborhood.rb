class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  extend SearchConcerns::ClassMethods
  include SearchConcerns::InstanceMethods


  def neighborhood_openings(start_range, end_range)
    openings(start_range, end_range)
  end

end
