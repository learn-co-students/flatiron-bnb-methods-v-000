class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :set_host
  after_destroy :unset_host

  after_destroy do
    if self.host.listings.count == 0
      self.host.update(:host => false)
    end
  end

  def average_review_rating
    num_reviews = self.reviews.count.to_f
    sum_rating = self.reviews.collect { |review| review.rating }.inject(0, :+)

    sum_rating / num_reviews
  end

  private

    def set_host
      self.host.update(:host => true)
    end

    def unset_host
      if self.host.listings.empty?
        self.host.update(:host => false)
      end
    end

end
