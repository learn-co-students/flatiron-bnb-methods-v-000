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

    after_save :set_host_status
    before_destroy :set_host_status_if_last_listing
    def average_review_rating
        @ratings = self.reviews.collect do |review| review.rating end
        @ratings.inject{ |sum, el| sum + el }.to_f / @ratings.size
    end

    private
    def set_host_status
        self.host.host = true
        self.host.save
    end
    def set_host_status_if_last_listing
        if self.host.listings.count == 1
            self.host.host = false
            self.host.save
        end
    end
end
