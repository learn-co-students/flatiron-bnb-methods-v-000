class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(start_date, end_date)
    list = []
    self.listings.each do |l|
      if l.reservations.empty?
        list << l
      else
        l.reservations.each do |r|
          if ((r.checkin...r.checkout) === start_date.to_date || (r.checkin...r.checkout) === end_date.to_date)
            break
          else
            list << l
          end
        end
      end
    end
    list
    #binding.pry
  end

  def self.highest_ratio_res_to_listings
    highest_resev_per_list = ""
    no_of_list = 0
    self.all.each do |city|
      city.listings.each do |list|
        if no_of_list < list.reservations.count
          no_of_list = list.reservations.count
          highest_resev_per_list = city
        end
      end
    end
    highest_resev_per_list
  end


  def self.most_res
    highest_resev_per_list = ""
    no_of_res = 0
    self.all.each do |city|
      tmp = 0
      city.listings.each do |list|
          tmp += list.reservations.count
      end
      if tmp >= no_of_res
        no_of_res = tmp
        highest_resev_per_list = city
      end
    end
    highest_resev_per_list

  end

end
