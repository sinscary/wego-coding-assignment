class CreateParkingLot < ActiveRecord::Migration[5.2]
  def change
    create_table :parking_lots do |t|
      t.string  :car_park_no
      t.text    :address
      t.string  :latitude
      t.string  :longitude
      t.integer :total_lots
      t.integer :available_lots
    end
  end
end
