# Flatiron BNB Methods Review

## README

- We already have our model associations in place.
- We need to build out our model validations and callbacks.
- Follow the fat models, skinny controller paradigm.

## RSpec

### Test Flow

I'm going to go through each test one by one using `rspec --fail-fast`. We'll start first with the `City` model.

### City

- The first test that's failing is `knows about all the available listings given a date range (FAILED - 1)`.

```ruby
# app/models/city.rb
def city_openings(start_date, end_date)
  openings = []
  self.listings.each do |listing|
    listing.reservations.each do |reservation|
      booked_dates = reservation.checkin..reservation.checkout
      unless booked_dates === start_date || booked_dates === end_date
        openings << listing
      end
    end
  end
end
```

- The second test that's failing is `knows the city with the highest ratio of reservations to listings (FAILED - 1)`. The first step is that we need to create a helper method that will grab all of the reservation counts for a city's listings - let's call it `find_res_count`.

```ruby
# app/models/city.rb
def find_reservation_count
  res_count = 0
  self.listings.each do |listing|
    res_count += listing.reservations.where(status: "accepted").count
  end
  res_count
end
```

- The next step is to actually build out the class method that will grab the highest ratio of a city's reservations to listings - let's put it in a method called `self.highest_ratio_res_to_listings`.

```ruby
# app/models/city.rb
def self.highest_ratio_res_to_listings
  # set up the ratio
  popular_city, highest_ratio = nil, 0.00
  self.all.each do |city|
    denominator = city.listings.count
    numerator = city.find_reservation_count
    if numerator.zero? || denominator.zero?
      next
    else
      popularity_ratio = numerator / denominator
      if popularity_ratio > highest_ratio
        highest_ratio = popularity_ratio
        popular_city = city
      end
    end
  end
  popular_city
end
```

- The next test that's failing is `knows the city with the most reservations (FAILED - 1)`. Let's go ahead and make a new class method called `self.most_res`. It will grab the city with the most reservations.

```ruby
# app/models/city.rb

def self.most_res
  most_reservations = "unknown"
  total_reservation_number = 0
  self.all.each do |city|
    city_reservation_number = city.find_reservation_count
    if city_reservation_number > total_reservation_number
      most_reservations = city
      total_reservation_number = city_reservation_number
    end
  end
  most_reservations
end
```

- Once this is passing, then we've got all of the tests passing for the `City` model. Let's move on to the `Listing` model.

### Listing

- The first failing test on the `Listing` model is - `is invalid without an address (FAILED - 1)`. There are validation tests for all of the listing attributes, so let's write a validation method for all of the attributes:

```ruby
# app/models/listing.rb
validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
```

- This knocks out all of the validation tests on the `Listing` model. The next failing test we get is `changes user host status when created (FAILED - 1)`, which is asking us for a callback method. Let's go ahead and create that now:

```ruby
# app/models/listing.rb
before_save :make_host

def make_host
  unless self.host.host
    self.host.update(:host => true)
  end
end
```

- The next failing test is `changes host status when deleted and host has no more listings (FAILED - 1)`. We need to be able to change the host status to false when the host of a listing has no more listings before a listing is destroyed.

```ruby
# app/models/listing.rb
before_destroy :host_status

def host_status
  if self.host.listings.count <= 1
    self.host.update(:host => false)
  end
end
```

- Now we're getting into the instance method tests for the `Listing` model. The next failure is `knows its average ratings from its reviews (FAILED - 1)`. We need to average out the ratings from each listing's reviews.

```ruby
# app/models/listing.rb
def average_rating
  total = 0
  self.reviews.each do |review|
    total += review.rating
  end
  average = total.to_f / self.reviews.count
end
```

- That's it for the `Listing` class specs.

### Neighborhood

- The first test failure we run into for the `Neighborhood` model is `knows about all the available listings given a date range (FAILED - 1)`. We need to create an instance method called `neighborhood_openings` that will determine the number of available listings in a given date range. Let's build it below:

```ruby
# app/models/neighborhood.rb
def neighborhood_openings(start_date, end_date)
  openings = []
  self.listings.each do |listing|
    listing.reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      unless booked_dates === start_date || booked_dates === end_date
        openings << listing
      end
    end
  end
  openings
end
```

- The next test failure is `knows the neighborhood with the highest ratio of reservations to listings (FAILED - 1)`. This is expecting a class method `self.highest_ratio_res_to_listings` that returns a neighborhood with the highest ratio of reservations to listings in a neighborhood. We also need to make a helper method, `find_reservation_count`, that will find the reservation count for a neighborhood.

```ruby
# app/models/neighborhood.rb
def self.highest_ratio_res_to_listings
popular_neighborhood = Neighborhood.create(:name => "Womp Womp.")
highest_ratio = 0.00
self.all.each do |neighborhood|
  denominator = neighborhood.listings.count
  numerator = neighborhood.find_reservation_count
  if denominator == 0 || numerator == 0
    next
  else
    popularity_ratio = numerator / denominator
    if popularity_ratio > highest_ratio
      highest_ratio = popularity_ratio
      popular_neighborhood = neighborhood
    end
  end
end
popular_neighborhood
end

def find_reservation_count
  reservation_count = 0
  self.listings.each do |listing|
    reservation_count += listing.reservations.where(:status => "accepted").count
  end
  reservation_count
end
```

- The next failing test in the `Neighborhood` model is `knows the neighborhood with the most reservations (FAILED - 1)`. We need to build a class method, `self.most_res`, that will grab the Neighborhood object with the most reservations.

```ruby
def self.most_res
  most_reservations = "currently unknown"
  total_reservation_number = 0
  self.all.each do |neighborhood|
    neighborhood_reservation_number = neighborhood.find_reservation_count
    if neighborhood_reservation_number > total_reservation_number
      total_reservation_number = neighborhood_reservation_number
      most_reservations = neighborhood
    end
  end
  most_reservations
end
```

- That's it for the `Neighborhood` model. Let's move on to the `Reservation` model.

### Reservation

- The first failing test in this model is `is invalid without a checkin (FAILED - 1)`. This is a validation test, so let's go ahead and write the validations for the `checkin` and `checkout` attributes of the `Reservation` model.

```ruby
# app/models/reservation.rb
validates_presence_of :checkin, :checkout
```

- The next failure is `validates that you cannot make a reservation on your own listing (FAILED - 1)`. We need to make a new method, `guest_and_host_not_the_same`, and run that method as a validation.

```ruby
# app/models/reservation.rb

validate :guest_and_host_not_the_same

def guest_and_host_not_the_same
  if self.guest_id == self.listing.host_id
    errors.add(:guest_id, "You can't book your own apartment")
  end
end
```

- The next failure is another validation: `validates that a listing is available at checkin before making reservation (FAILED - 1)`. Let's build a method called `check_availability`, and run that as a validation.

```ruby
# app/models/reservation.rb

validate :check_availability

def check_availablity
  self.listing.reservations.each do |r|
    booked_dates = r.checkin..r.checkout
    if booked_dates === self.checkin || booked_dates === self.checkout
      errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
    end
  end
end
```

- The next failure is yet another validation: `validates that checkin is before checkout (FAILED - 1)`. Let's build a method called `checkout_after_checkin` and run it as a validation.

```ruby
# app/models/reservation.rb

validate :checkout_after_checkin

def checkout_after_checkin
  if self.checkout && self.checkin
    if self.checkout <= self.checkin
      errors.add(:guest_id, "Your checkin date needs to be after your checkout date")
    end
  end
end
```

- Now we hit a failure on an instance method: `knows about its duration based on checkin and checkout dates (FAILED - 1)`. We need to build a `duration` method that returns the length of a reservation (in days).

```ruby
# app/models/reservation.rb

def duration
  (self.checkout - self.checkin).to_i
end
```

- The next failure is a method regarding the price of the reservation: `knows about its total price (FAILED - 1)`. We need to build a `total_price` method that returns the total price of a reservation.

```ruby
# app/models/reservation.rb

def total_price
  self.listing.price * duration
end
```

- That's it for the `Reservation` model tests. Let's move on to `Review` model tests.

### Review

- The first failing test in the `Review` model is a validation error: `is invalid without a rating (FAILED - 1)`. Let's go ahead and write up validations for all of the `Review` model attributes:

```ruby
# app/models/user.rb

validates_presence_of :description, :rating, :reservation_id
```

- Once the attribute validation tests are passing, we get this error: `is invalid without an associated reservation, has been accepted, and checkout has happened (FAILED - 1)`. This test is failing because you can submit a review on a reservation that doesn't exist, or has not been accepted yet.

```ruby
# app/models/user.rb

validate :reservation_exists_and_accepted_hasnt_happened_yet

def reservation_exists_and_accepted_hasnt_happened_yet
  errors.add(:reservation_id, "doesn't exist") unless Reservation.exists?(reservation_id) && Reservation.find(reservation_id).status == "accepted" && Reservation.find(reservation_id).checkout < Date.today
end
```

- That's it for the `Review` model tests.

### User

- The first failing test in this model is `as a host, knows about the guests its had (FAILED - 1)`. We need to write a guests method that will grab all of the guests that a host has had through its listing.

```ruby
# app/models/user.rb

def guests
  host_guests = []
  self.listings.each do |listing|
    listing.reservations.each do |reservation|
      host_guests << reservation.guest
    end
  end
  host_guests
end
```

OR

```ruby
# app/models/user.rb

has_many :guests, :through => :reservations, :class_name => "User"
```

- The next failure is `as a guest, knows about the hosts its had (FAILED - 1)`. A guest should know about all of the hosts that he/she has had.

```ruby
# app/models/user.rb
def hosts
  self.trips.collect do |trip|
    trip.listing.host
  end
end
```

OR

```ruby
# app/models/user.rb

has_many :trip_listings, :through => :trips, :source => :listing
has_many :hosts, :through => :trip_listings, :foreign_key => :host_id
```

- The next error we get is about a host knowing about the reviews from their guests: `as a host, knows about its reviews from guests (FAILED - 1)`.

```ruby
# app/models/user.rb
def host_reviews
  guests.collect do |guest|
    guest.reviews
  end.flatten
end
```

- Now you've completed all of the tests!
