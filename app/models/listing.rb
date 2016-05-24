class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  before_create :set_host

  def set_host
    #binding.pry
    unless self.host.host == true
      self.host.host = true
    end
  end
end
