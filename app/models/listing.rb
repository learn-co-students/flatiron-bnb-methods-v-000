class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_save :change_host_status
  after_destroy :remove_host_status

  def average_review_rating
    x = 0
    self.reviews.each do |review|
      x += review.rating
    end
    average_rating = x/self.reviews.count.to_f
  end

  private

    def change_host_status
      self.host.update(host: true)
    end

    def remove_host_status
      if self.host.listings.count <= 0
        self.host.update(host: false)
      end
    end

end
