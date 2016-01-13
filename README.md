# Flatiron-bnb: Methods

In the previous iteration, we built out our model associations and migrated our database. Now we're going to work on building useful methods (class and instance) for rendering data and our own validations. We're doing this to follow the principle that our controllers should be skinny, our models fat, so therefore our views have very little logic in them.

**Before anything**, note that when you generate models, controllers, etc, be sure to include this option, so that it skips tests (which we already have): `--no-test-framework`

## Instructions

There are many methods here. Check out the specs and **remember to run your code in `rails c`** that will help, I promise!

### City

  * The `#city_openings` should return all of the `Listing` objects that are available for the **entire span** that is inputted. 
  * The `.highest_ratio_res_to_listings` method should return the `City` that is "most full". What that means is it has the highest amount of reservations per listing.
  * The `.most_res` method should return the `City` with the most total number of reservations, no matter if they are all on one listing or otherwise.

### Listing

#### Validations

  * You'll need to write a few validations here, they are all pretty straight forward, just take a look at the tests!

#### Callbacks

  * Whenever a listing is created, the user attached to that listing should be converted into a "host". This means that that users `host` field is set to `true`
  * whenever a listing is destroyed (new callback! Google it!) the user attached to that listing should be converted back to a regular user. That means setting the `host` field to false.

### Neighborhood

The same class/instance methods as your `City` object. Maybe there is a way they can share code?!?!?

### Reservation

#### Validations

  * Should have a `checkin` and a `checkout`
  * Make sure the guest and host aren't the same user.
  * Make sure any reservation that is made, doesn't conflict with others.
  * Make sure the checkout time is after the check in time

#### Methods

  * `#duration` gives the duration in days
  * `#total_price` returns the price using the duration and the price per day of the listing

### Review

#### Validations

  * Should have a description, rating and reservation
  * Reviews should only be created on reservations that exist and haven't happened yet.

## Resources

* [About Private Methods](http://stackoverflow.com/a/4293330/2890716)
* [AR Validations](http://guides.rubyonrails.org/active_record_validations.html)
* [Rails Callbacks](http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html)

<a href='https://learn.co/lessons/flatiron-bnb-methods' data-visibility='hidden'>View this lesson on Learn.co</a>
