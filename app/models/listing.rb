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

  after_create :change_host_status_to_true
  after_destroy :change_host_status_to_false

def average_review_rating
  total_review_score / self.reviews.count.to_f
end

protected
  def total_review_score
    self.reviews.inject(0) do |sum, rev|
      sum += rev.rating
    end
  end

  def change_host_status_to_true
    self.host.host = true
    self.host.save
  end

  def change_host_status_to_false

    self.host.host = false if self.host.listings.count == 0
    self.host.save
  end

end
