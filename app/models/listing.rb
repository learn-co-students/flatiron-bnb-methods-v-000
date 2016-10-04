class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations


  validates :address, :title, :description, :price, :listing_type, :neighborhood, presence: true
  
    after_save :set_to_true
  # before_destroy :set_to_false

    def set_to_true
      if self.host[:host] = false
        self.host[:host] = true
        user = self.host[:host]
        user.save
      end
    end


end
