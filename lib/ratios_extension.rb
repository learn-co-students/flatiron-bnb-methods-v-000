module RatiosExtension

    def most_res
      #binding.pry
      self.all.max_by {|city| city.reservations.length}
    end

    def highest_ratio_res_to_listings
      #binding.pry
      #self.all.max_by {|object| object.reservations.length}
    end

    def neighborhood_openings(date1, date2)

    end

end

# lib/ratios_extension.rb:15
# spec/models/city_spec.rb:21