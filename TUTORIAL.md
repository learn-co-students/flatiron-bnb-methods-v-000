# Guide to Solving Flatiron BnB Methods

## Overview

In a previous version of Flatiron BnB, we built out the tables, models, and associations for our application. Today, we'll be extending their functionality through additional methods, associations, and validations. This will make it really easy to add more complex data into our controllers and views. For example, we may want to list the most popular cities on our home page. We can give our model a method, `highest_ratio_res_to_listings`, that returns the city with the highest "booked" percentage. This is much neater than including that logic into our controller or view. 

We'll also be using instance methods to add validations for our models. For example, our users shouldn't be able to create reservations on listings that are booked during that time. 

## Steps

1). After running `rspec`, we can see that all of our associations are passing. However, we may need to add more associations to get some of our other tests passing. For example, our first failing test is that a city `knows about the available listings in a given date range`. To make this pass, we'll update our `City` model so that it `has_many :reservations, :through => :listings`. 

```ruby
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
 
2). 

