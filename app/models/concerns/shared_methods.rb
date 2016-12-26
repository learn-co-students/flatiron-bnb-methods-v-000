module SharedMethods
  extend ActiveSupport::Concern

  def highest_ratio_res_to_listings
    self.all.max_by { |c| c.listings.count == 0 ? 0 : c.reservations.count / c.listings.count }
  end

  def most_res
    self.all.max_by { |c| c.reservations.count }
  end

end
