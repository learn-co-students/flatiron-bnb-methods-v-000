# Guide to Solving Flatiron BnB Methods

## Overview

In a previous version of Flatiron BnB, we built out the tables, models, and associations for our application. Today, we'll be extending their functionality through additional methods, associations, and validations. This will make it really easy to add more complex data into our controllers and views. For example, we may want to list the most popular cities on our home page. We can give our model a method, `highest_ratio_res_to_listings`, that returns the city with the highest "booked" percentage. This is much neater than including that logic into our controller or view. 

We'll also be using instance methods to add validations for our models. For example, our users shouldn't be able to create reservations on listings that are booked during that time. 

## Steps

### City Spec

1). After running `rspec`, we can see that all of our associations are passing. However, we may need to add more associations to get some of our other tests passing. For example, our first failing test is that a city `knows about the available listings in a given date range`. To make this pass, we'll update our `City` model so that it `has_many :reservations, :through => :listings`. 

```ruby
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
```

Now, we'll define our `city_openings` method to take two arguments, a `start_date` and an `end_date`. We can iterate through the reservations associated with `self` and keep track of any listing that doesn't have a reservation for that day. We're using the reservation's checkin and checkout to create a date range. Comparing a date range to a single date using `===` will return true if the single date overlaps with the range. Therefore, we can compare our reservation's range to the start date and the end date to make sure there's no overlap. 

```ruby
def city_openings(start_date, end_date)
    reservations.collect do |r|
      booked_dates = r.checkin..r.checkout
      unless booked_dates === start_date || booked_dates === end_date
        r.listing
      end
    end
  end
```



2). `highest_ratio_res_to_listings` - for the next test, we'll create a class method to return the City with the highest ratio of reservations to listings. You can imagine using this in our controller - `@most_popular_city = City.highest_ratio_res_to_listings` that could be displayed in a view. Including this logic in our model helps keep our controllers and views lightweight. 

To find the highest reservations to listings ratio, we need each instance of city to be able to calculate it's reservations to listings. Let's create a helper method, `ratio_res_to_listing` for instances of cities. 

```ruby
def ratio_res_to_listings
  	if listings.count > 0
  		reservations.count.to_f / listings.count.to_f
  	else
  		0
  	end
end
```

Since dividing by 0 is a big no-no, we only run this calculation if our number of listings is great than or equal to 1. Otherwise, this method will return 0. 

Now, we can simply iterate through each city and keep track of the one whose value is highest. 

```ruby
def self.highest_ratio_res_to_listings
  highest = self.first
  self.all.each do |city|
    if city.ratio_res_to_listings > highest.ratio_res_to_listings
      highest = city
    end
  end
  highest
end
```

3. Finally, we want our `City` class to be able to return the city with the most reservations. The logic here is the same as finding the highest_ratio_res_to_listings method, only comparing a count of reservations instead.

```ruby
def self.most_res
  most_reservations = self.first
  self.all.each do |city|
    if city.reservations.count > most_reservations.reservations.count
      most_reservations = city
    end
  end
  most_reservations
end
```

Our City model is now passing all of our tests - awesome!

### Neighborhood Spec
