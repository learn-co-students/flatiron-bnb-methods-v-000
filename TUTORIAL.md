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

1). Let's move on to the `neighborhood` spec next. The tests are running in alphabetical order, but remember that we can run them in any order we want by specifying the file. For example, `rspec spec/models/neighborhood_spec.rb` will run only the tests in the `neighborhood_spec` file. 

The three failing tests here should look familiar - they're exactly the same as our `city` tests. In fact, we can copy and paste the contents of our `city_openings` method into our `neighborhood_openings` method. 

```ruby
def neighborhood_openings(start_date, end_date)
  reservations.collect do |r|
    booked_dates = r.checkin..r.checkout
    unless booked_dates === start_date || booked_dates === end_date
      r.listing
    end
  end
end
```

2). For our class methods, we can re-use what we wrote for our City model. 

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

### Review Spec

Next, let's take a look at some of our validations. Validations are ways to make sure that only valid data is saved to the database. Client-side validations won't allow users to fill out a form without certain fields, but can be unreliable when used alone. Adding server-side validations to Rails makes sure that we only end up with valid results.

Let's start with the Review spec. For example, two basic validations are that a review must include a rating and a description. We'll add a line to our model: `validates :description, :rating, :reservation, presence: true`

```ruby
class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, :rating, :reservation, presence: true
```

We can also write a custom validation method. This method should be private we never want to call these validation methods outside of our class. 

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

Awesome. Next, we need to make sure that the listing is available. To do this, we'll need to iterate through the listings other reservations and compare the booked dates with our reservation's start and end dates. 

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

Awesome job. Our `listing` spec should be all green now!

### User

The `user` tests concern our User model having different behaviors as a host vs as a guest. 




