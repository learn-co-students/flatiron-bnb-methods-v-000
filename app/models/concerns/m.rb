module M
  extend ActiveSupport::Concern

  def openings(start_date, end_date)
    listings.select{|x| !x.occupied?(start_date, end_date)}
  end

  def highest_ratio
    if listings.count == 0
      0
    else
      listings.max_by{|x| x.res_num}.res_num
    end
  end

  def res_num
    ans = 0
    listings.each{|x| ans += x.res_num}
    ans
  end

  class_methods do

    def highest_ratio_res_to_listings
      all.max_by{|x| x.highest_ratio}
    end

    def most_res
      all.max_by{|x| x.res_num}
    end
    
  end

end
