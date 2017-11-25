class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :guests, through: :reservations, class_name: :User
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :host_reviews, through: :guests, source: :reviews

  def guests
    User.all.select do |user|
      !user.host
    end
  end

  def hosts
    User.all.select do |user|
      user.host
    end
  end

end
