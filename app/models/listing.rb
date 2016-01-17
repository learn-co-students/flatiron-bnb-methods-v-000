class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  before_save :change_user_status
  before_destroy :maybe_change_user_status
  
  def change_user_status
    user = self.host
    user.update(host: true)
    user.save
  end

  def maybe_change_user_status
    user = self.host
    if user.listings.count == 1
      user.update(host: false)
      user.save
    end
  end

  def average_review_rating
    counter = 0
    total = 0
    self.reviews.each do |a|
      total += a.rating
      counter += 1
    end
    total/counter.to_f
  end

end
