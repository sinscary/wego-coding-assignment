require 'test_helper'

class ParkingLotTest < ActiveSupport::TestCase

  setup do
    ParkingLot.create!(car_park_no: "C37", address: "BLK 715-717 CLEMENTI WEST STREET 2", longitude: "103.7609", latitude: "1.307", "available_lots": 100)
    ParkingLot.create!(car_park_no: "C39", address: "BLK 715-717 CLEMENTI WEST STREET 2", longitude: "103.8969", latitude: "1.374", "available_lots": 0)
    ParkingLot.create!(car_park_no: "C40", address: "BLK 715-717 CLEMENTI WEST STREET 2", longitude: "103.8963", latitude: "1.375", "available_lots": 410)
  end

  test "must raise an error if latitude is not present" do
    error = assert_raises(ActiveRecord::RecordInvalid) do
      ParkingLot.create!(
        car_park_no: "C38",
        address: "BLK 715-717 CLEMENTI WEST STREET 2",
        longitude: "103.7625"
      )
    end
    assert_equal error.message, "Validation failed: Latitude can't be blank"
  end

  test "must raise an error if longitude is not present" do
    error = assert_raises(ActiveRecord::RecordInvalid) do
      ParkingLot.create!(
        car_park_no: "C38",
        address: "BLK 715-717 CLEMENTI WEST STREET 2",
        latitude: "1.302"
      )
    end
    assert_equal error.message, "Validation failed: Longitude can't be blank"
  end

  test "must raise an error if address is not present" do
    error = assert_raises(ActiveRecord::RecordInvalid) do
      ParkingLot.create!(
        car_park_no: "C38",
        latitude: "1.302",
        longitude: "103.7625"
      )
    end
    assert_equal error.message, "Validation failed: Address can't be blank"
  end

  test "must raise an error if car_park_no is not present" do
    error = assert_raises(ActiveRecord::RecordInvalid) do
      ParkingLot.create!(
        address: "BLK 715-717 CLEMENTI WEST STREET 2",
        latitude: "1.302",
        longitude: "103.7625"
      )
    end
    assert_equal error.message, "Validation failed: Car park no can't be blank"
  end

  test "must raise error if multiple record is created with same car_park_no" do
    error = assert_raises(ActiveRecord::RecordInvalid) do
      ParkingLot.create!(
        car_park_no: "C39",
        address: "BLK 715-717 CLEMENTI WEST STREET 2",
        longitude: "103.7625",
        latitude: "1.302"
      )
    end
    assert_equal error.message, "Validation failed: Car park no has already been taken"
  end

  test "must return all the nearby available parking lots" do
    total_parking_lot = ParkingLot.all.count
    available_parking_lot = ParkingLot.where("available_lots > 0").count
    nearest_available = ParkingLot.fetch_nearest(
      latitude: 1.37326, 
      longitude: 103.897,
      page: 1,
      per_page: 5
    )
    assert_equal total_parking_lot, 3
    assert_equal available_parking_lot, 2
    assert_equal nearest_available.size, 1
  end

end