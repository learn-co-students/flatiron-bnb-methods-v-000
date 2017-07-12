class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :description, null: false
      t.integer :rating, null: false
      t.integer :guest_id
      t.integer :reservation_id
      t.timestamps null: false
    end
  end
end
