class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, :host, presence: true

  before_save :toggle_user_host_status

  # using after_destroy. Might need before_destroy in order to see object attributes?
  after_destroy :check_user_host_status

  private

  def toggle_user_host_status
    self.host.host = true if self.host.host == false
    self.host.save
  end

  # this is a little odd, the listing has been "destroyed" but I still have access to self.attributes. The if statement is therefor if the host has LESS THAN ONE listing (presumably because the last one just got destroyed?).
  def check_user_host_status
    if self.host.listings.size < 1 # presumably this listing WAS the last one
      self.host.host = false
      self.host.save
    end
  end
end
