# Guide to Solving Flatiron BnB Methods

## Overview

In a previous version of Flatiron BnB, we built out the tables, models, and associations for our application. Today, we'll be extending their functionality through additional methods, associations, and validations. This will make it really easy to add more complex data into our controllers and views. For example, we may want to list the most popular cities on our home page. We can give our model a method, `highest_ratio_res_to_listings`, that returns the city with the highest "booked" percentage. This is much neater than including that logic into our controller or view. We'll also be using instance methods to add validations for our models. For example, our users shouldn't be able to create reservations on listings that are booked during that time. 


Why is this important? First, adding validations makes sure that only the data we want will get stored in the database. It wouldn't make sense to have listings without hosts, or reservations where the checkout date comes before the checkin.  Validating this data when it's saved allows us to make certain assumptions about the state of our application in the future. 

Second, adding instance and class methods to retrieve certain interesting information from our Models will keep our controllers and views nice and light. It's much nicer to write `City.highest_ratio_res_to_listings` in the controller than iterating through those items each time. This pattern is called "Fat models, skinny controllers" and is very strong in Rails.

There are tons of tests here. We'll go through the specs one at a time. 


## Steps to Solve


### Review Spec

To begin, let's set up some validations. ActiveRecord validations make sure that only valid data is saved to the database. For example, we don't want to save any reviews that aren't associated with a reservation. 

Let's start with the Review spec. For example, three basic validations are that a review must include a reservation, rating and a description. We'll add a line to our model: `validates :description, :rating, :reservation, presence: true`

```ruby
class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
```

We can also write a custom validation method. This method should be private, as we don't want to expose them to other parts of our application. 

```ruby
class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
  validate :reservation_exists_and_accepted_hasnt_happened_yet

  private
  #You can't write a review on a reservation that doesn't exist
  def reservation_exists_and_accepted_hasnt_happened_yet
    errors.add(:reservation, "not valid") unless reservation
  end

```

This method will create an error unless there's a reservation associated with the review. Let's also check that the reservation has an "accepted" status, and that the checkout date is in the past.

```ruby
class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
  validate :reservation_exists_and_accepted_hasnt_happened_yet

  private
  #You can't write a review on a reservation that doesn't exist
  def reservation_exists_and_accepted_hasnt_happened_yet
    errors.add(:reservation, "not valid") unless reservation && reservation.status == "accepted" && reservation.checkout < Date.today
  end

```

### Reservation Spec

Let's add some validations to our reservation. First, we need to validate the presence of checkin and checkout. 

```ruby
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
```

Next, let's add some custom validations. A user can't book their own listing, meaning that the reservation's listing's host can't be the same as the reservation's guest. 

```ruby
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_and_host_not_the_same

  private
  # Make sure guest and host not the same
  def guest_and_host_not_the_same
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end
```

Awesome job. Next, we need to make sure that the listing is available. To do this, we'll need to iterate through the listings other reservations and compare the booked dates with our reservation's start and end dates. 

```ruby
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_and_host_not_the_same, :check_availability

  private
  # Make sure guest and host not the same
  def guest_and_host_not_the_same
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def check_availablity
    self.listing.reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end
```

Lastly, we need to make sure that the checkout isn't before the checkin date, because that wouldn't make sense. We check that both are present first, to avoid comparing an integer with nil. 

```ruby
class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_and_host_not_the_same, :check_availability, :checkout_after_checkin

  private
  # Make sure guest and host not the same
  def guest_and_host_not_the_same
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def check_availablity
    self.listing.reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === self.checkin || booked_dates === self.checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def checkout_after_checkin
    if self.checkout && self.checkin
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Your checkin date needs to be after your checkout date")
      end
    end
  end
```

Awesome, our validations are complete! This process should feel similar to adding the validations to our review. To finish our reservation spec, we'll define two instance methods: one called `duration` that returns the length in days, and one called `total_price` that returns the total price of the reservation. These methods should be public - we'll want to access them in other parts of our application. For example, you could imagine calling this in a view to display to our user.

```ruby

  # Returns the length (in days) of a reservation
  def duration
    (self.checkout - self.checkin).to_i
  end

  # Given the duration of the stay and the listing price, returns how much does the reservation costs
  def total_price
    self.listing.price * duration
  end
```
Now, our reservation spec should be passing. Awesome job! Let's move on.

### Listing Spec

Adding validations to our listing spec should look familiar at this point. We need to make sure that address, listing_type, title, description, price, and neighborhood aren't blank.

```ruby
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
```

Now that our listing's been validated, we need to add some custom callbacks. When a user posts a listing, their status of `host` should update. We can hook into the moment in time when a listing is saved and update this using ActiveRecord's `before_save` callback. First, let's define a method that changes the listing's user's host_status to `true`. Like our other callback methods, this should be private.

```ruby
private
  # Makes user a host when a listing is created
  def make_host
    unless self.host.host
      self.host.update(:host => true)
    end
  end
```

This method `make_host` checks to see if the listing's host's host has a status that returns true. If it returns false, it updates that property to `true`. Now, let's run that method when the listing is saved.

```ruby
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :make_host
```
Awesome. Along the same lines, we need to check our host's status when the listing is destroyed. If the user has no other listings, their host status should be changed to `false`.

```ruby
  # Changes host status to false when listing is destroyed and user has no more listings
  def host_status
    if self.host.listings.count <= 1
      self.host.update(:host => false)
    end
  end
```

We can use the `before_destroy` callback to run this method when a listing is destroyed. 

```ruby
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :make_host
  before_destroy :host_status
```

We need to add one instance method to our Listing - `average_review_rating` should return the average rating from all of the reviews on our listing. For this one, we can use one of ActiveRecord's cool [caluclation methods](http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html) - in this case, average. 

```ruby
def average_review_rating
	self.reviews.average(:rating)
end
```

Awesome job. Our `listing` spec should be all green now!

### User

The `user` tests concern our User model having different behaviors as a host vs as a guest. We could, if we wanted to, define our own instance methods to return these values. However, in this case, it makes more sense to add ActiveRecord associations. 

First, as a host, our user should know about the guests that it's had. Since our host has many reservations through listings, and reservations have many guests, we can use this association to allow our host to have many guests. 

```ruby
class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  ## As a host
  has_many :guests, :through => :reservations, :class_name => "User"
end
```

Our host can also have many `host_reviews` through the guests.

```ruby
class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  ## As a host
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :guests, :source => :reviews
end
```

Because we're using the name `host_reviews`, we need to declare the source of this relationship. ActiveRecord will know to use the reviews table to find associated `host_reviews` where the guest and the host are in common via the reservation.

Lastly, our guests should know about all of their hosts. For this, we'll first need to pull up all of the listings from our trips. Our hosts already have many listings that belong to them directly, but our guests also have many trip_listings from the trips they've booked.

```ruby
class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  ## As a guest
  has_many :trip_listings, :through => :trips, :source => :listing

  ## As a host
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :guests, :source => :reviews
end
```

From here, we can add that a guest `has_many hosts through: trip_listings`, specifying that the foreign_key we're looking at is the `host_id`

```ruby
class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  ## As a guest
  has_many :trip_listings, :through => :trips, :source => :listing
  has_many :hosts, :through => :trip_listings, :foreign_key => :host_id

  ## As a host
  has_many :guests, :through => :reservations, :class_name => "User"
  has_many :host_reviews, :through => :guests, :source => :reviews
end
```

And that's it! All of our tests are passing.

### City Spec

Let's define a method, `city_openings`, that returns takes in two dates as arguments and returns any listings that aren't booked during that range. This means that calling `@city.city_openings("2015-05-01", "2015-05-05")` should only return listings that are available during that entire time.

After running `rspec`, we can see that all of our associations are passing. However, we may need to add more associations to get some of our other tests passing. For example, our first failing test is that a city `knows about the available listings in a given date range`. To make this pass, we'll update our `City` model so that it `has_many :reservations, :through => :listings`. 

```ruby
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
```

For the next test, we'll create a class method to return the City with the highest ratio of reservations to listings. You can imagine using this in our controller to create a 	`@most_popular_city` instance variable as so:  `@most_popular_city = City.highest_ratio_res_to_listings` This could then be displayed in any of our views.  Including this logic in our model helps keep our controllers and views lightweight. 

To find the highest reservations to listings ratio, we need each instance of city to be able to calculate the ratio of reservations to listings. Let's create a helper method, `ratio_res_to_listing` for instances of cities. 

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

Finally, we want our `City` class to be able to return the city with the most reservations. The logic here is the same as finding the `highest_ratio_res_to_listings method`, only comparing a count of reservations instead.

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

Let's move on to the `neighborhood` spec next. The tests are running in alphabetical order, but remember that we can run them in any order we want by specifying the file. For example, `rspec spec/models/neighborhood_spec.rb` will run only the tests in the `neighborhood_spec` file. 

The three failing tests here should look familiar - they're exactly the same as our `city` tests. In fact, we can copy and paste the contents of our `city_openings` method into our `neighborhood_openings` method. 

```ruby
def neightborhood_openings(start_date, end_date)
    open_listings = listings.collect {|l| l if l.reservations.count == 0}
    reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      unless booked_dates === Date.parse(start_date) || booked_dates === Date.parse(end_date)
        open_listings << r.listing
      end
    end
    open_listings.uniq
  end
```

For our class methods, we can re-use what we wrote for our City model verbatim. 

```ruby
# Returns nabe with highest ratio of reservations to listings
def self.highest_ratio_res_to_listings
  highest = self.first
  self.all.each do |neighborhood|
    if neighborhood.ratio_res_to_listings > highest.ratio_res_to_listings
      highest = neighborhood
    end
  end
  highest
end

# Returns nabe with most reservations
def self.most_res
  most_reservations = self.first
  self.all.each do |neighborhood|
    if neighborhood.reservations.count > most_reservations.reservations.count
      most_reservations = neighborhood
    end
  end
  most_reservations
end

```
That'll get the tests passing. It's a little bit annoying that we had to copy/paste that code. As a bonus, think about how we could include those methods on both classes...


## Conclusion/So What?

That was a long lab - give yourself a pat on the back. Some of the big takeaways are:

1. We can use instance and class methods to get custom data out of our models. Doing this will make our lives much easier in our controllers and views.
2. We can use ActiveRecord Associations to setup complex relationships where users have different associations based on behavior. 
3. We can use ActiveRecord validations to make sure that only data we want is saved to our database.

