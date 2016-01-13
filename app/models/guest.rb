class Guest < ActiveRecord::Base
  belongs_to :user
  has_many :reservations

  def name
    user.name
  end
end