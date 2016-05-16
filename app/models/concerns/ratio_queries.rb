  module RatioQueries
    extend ActiveSupport::Concern


def ratio
  if listings.count > 0
    reservations.count.to_f / listings.count.to_f
  else
    0
  end
end

class_methods do


  def highest_ratio_res_to_listings
     all.max do |a, b|
       a.ratio <=> b.ratio
     end
  end


  def most_res
    all.max do |a, b|
      a.reservations.count <=> b.reservations.count
     end
   end
  end
end
