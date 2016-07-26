class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  validates :name, presence: true

  def neighborhood_openings(start_date, end_date)
    #if (start_date <= end_date && end_date >= start_date)
    list = []
      self.listings.each do |l|
        l.reservations.each do |r|
          if ((r.checkin...r.checkout) === start_date.to_date || (r.checkin...r.checkout) === end_date.to_date)
            break
          else
            list << l unless r.nil?
          end
        end

      end
    #end
    list
  end

  def self.highest_ratio_res_to_listings

    highest_resev_per_list = ""
    no_of_list = 0
    self.all.each do |nabe|
      nabe.listings.each do |list|
        if no_of_list < list.reservations.count
          no_of_list = list.reservations.count
          highest_resev_per_list = nabe
        end
      end
    end
    highest_resev_per_list
  end


  def self.most_res
    highest_resev_per_list = ""
    no_of_res = 0
    self.all.each do |nabe|
      tmp = 0
      nabe.listings.each do |list|
          tmp += list.reservations.count
      end
      if tmp >= no_of_res
        no_of_res = tmp
        highest_resev_per_list = nabe
      end
    end
    highest_resev_per_list

  end

end
