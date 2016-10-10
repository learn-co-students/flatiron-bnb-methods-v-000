 Reservation >> 
  listing_id >> 
  neighborhood_id >> 
  city_id

Find city

Find all Reservations

Sort by city

Group by city

Count groups

Return highest




   
#   all_reservations = Reservation.all 
#   all_listings = []
#   all_neighborhoods = []
#   all_cities = []
#   cities_hash = Hash.new

#   all_reservations.each do |res|
#     all_listings << Listing.find_by(id: res.listing_id)
#   end

#   all_listings.each do |listing|
#     all_neighborhoods << Neighborhood.find_by(id: listing.neighborhood_id)
#   end

#   all_neighborhoods.each do |neighborhood|
#     all_cities << City.find_by(id: neighborhood.city_id)
#   end

#   all_cities.each do |city|
#   cities_hash[city].count

# binding.pry
#   end

# end


# def total_reservations(city)
#   reservation.listing.neighborhood.city.count
# end

# goal: a Hash of {city_name => res_total_for_city}



# res = [1, 1, 1, 2, 4, 4] 
# counts = Hash.new(0)
# res.each { |rnum| rnum[res] += 1 }

# >> res=Hash[a.group_by {|x| x}.map {|k,v| [k,v.count]}]
# => {"cat"=>1, "dog"=>1, "fish"=>2}

# >> a = ['cat','dog','fish','fish'] #=> ["cat", "dog", "fish", "fish"]
#  res2 = res.each_with_object(Hash.new(0)) { |k, v| v[k] }

# m = {}

# a.each do |e|
#   m[e] = 0 if m[e].nil?
#   m[e] = m[e] + 1
# end

# 2.2.3 :011 > res.each do |e|
# 2.2.3 :012 >     m[e] = 0 if m[e].nil?
# 2.2.3 :013?>   m[e] = m[e] + 1
# 2.2.3 :014?>   end

 


