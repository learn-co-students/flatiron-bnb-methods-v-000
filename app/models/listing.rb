class Listing < ActiveRecord::Base

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_create :set_host
  before_destroy :unset_host


  def average_review_rating
    reviews.average(:rating)
  end



  private

    def set_host
      self.host.host = true
      self.host.save
    end

    def unset_host
      if self.host.listings.count == 1
        self.host.host = false
        self.host.save
      end
    end

end
