---
tags: rails, full application, class methods, instance methods, validations, callbacks, private methods, scope
language: ruby
unit: rails
module: Helper Methods
level: advanced
resources: 2
---

# Flatiron-bnb: Methods

In the previous iteration, we built out our model associations and migrated our database. Now we're going to work on building useful methods (class and instance) for rendering data and our own validations. We're doing this to follow the principle that our controllers should be skinny, our models fat, so therefore our views have very little logic in them.

<em>Before anything</em>, note that when you generate models, controllers, etc, be sure to include this option, so that it skips tests (which we already have): `--no-test-framework`

## Instructions

There are many methods and validations and callbacks to build! <em>Work together</em>. Get the tests to pass. Read the resources listed.

## About Validations

Validations "allow you to declaritively define valid states for your model objects. The validation methods hook into the life cycle of an Active Record model object and re able to inspec the object to determine whether certain attributes are set, have values in a given range, or pass any other logical hurdles that you specify." (The Rails 4 Way, pg 241)

## About Callbacks

Callbacks are ways to attach methods/behavior to different points of a model's life cycle, like before saving and before destroying.

## About Scope

Scopes make it possible to define and chain query criteria. We're going to use scopes to clarify that 

### Hints

You will need to make a few new migrations to add some columns to some tables, and they should have default values.

## Resources

[AR Validations](http://guides.rubyonrails.org/active_record_validations.html)
[Rails Callbacks](http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html)