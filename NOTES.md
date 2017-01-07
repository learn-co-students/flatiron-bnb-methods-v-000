def self.highest_ratio_res_to_listings
  city_res_count = 0
  highest_city = nil

  self.all.each do |city|
    city.listings.each do |l|
      if city_res_count < l.reservations.count
        city_res_count = l.reservations.count
        highest_city = city
      end
    end
  end
  highest_city
end

NYC l1(3), l2(5)
Philly l3(1), l4(2)

NYC
l1
if 0 < 3
city_res_count = 3
highest_city = NYC

l2
if 3 < 5
city_res_count = 5
highest_city = NYC

Philly
l3
if 5 < 1
