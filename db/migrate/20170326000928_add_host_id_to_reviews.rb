class AddHostIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :host_id, :integer
  end
end
