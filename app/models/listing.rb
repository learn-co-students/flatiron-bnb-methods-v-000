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
  validates :neighborhood_id, presence: true
  before_create :change_host_status_to_true
  after_destroy :change_host_status_to_false

  def change_host_status_to_true
    user = User.find_by(id: self.host_id)
    user.update(host: true)
  end

  def change_host_status_to_false
    user = User.find_by(id: self.host_id)

    if user.listings.count == 0
      user.update(host: false)
    end
  end

  def average_review_rating
   reviews.average(:rating)
  end

end
