class CreateHospitalities < ActiveRecord::Migration
  def change
    create_table :hospitalities do |t|
      t.integer :user_id
      t.integer :guest_id

      t.timestamps null: false
    end
  end
end
