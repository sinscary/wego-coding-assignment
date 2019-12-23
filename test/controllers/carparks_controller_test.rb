class CarparksControllerTest < ActionDispatch::IntegrationTest

  setup do
    ParkingLot.create!(car_park_no: "C37", address: "BLK 715-717 CLEMENTI WEST STREET 2", longitude: "103.7609", latitude: "1.307", "available_lots": 100)
    ParkingLot.create!(car_park_no: "C39", address: "BLK 715-717 CLEMENTI WEST STREET 2", longitude: "103.8969", latitude: "1.374", "available_lots": 0)
    ParkingLot.create!(car_park_no: "C40", address: "BLK 715-717 CLEMENTI WEST STREET 2", longitude: "103.8963", latitude: "1.375", "available_lots": 410)
  end

  test "it returns error if latitude is not passed" do
    get carparks_nearest_url, params: {
     "longitude": 103.897,
     "page": 1,
     "per_page": 5
    }
    result = JSON.parse(response.body)
    assert_equal response.code, "400"
    assert_equal result["error"], "longitude and latitude are required"
  end

  test "it returns error if longitude is not passed" do
    get carparks_nearest_url, params: {
     "latitude": 103.897,
     "page": 1,
     "per_page": 5
    }
    result = JSON.parse(response.body)
    assert_equal response.code, "400"
    assert_equal result["error"], "longitude and latitude are required"
  end

  test "it returns nearby available parking lots only" do
    get carparks_nearest_url, params: {
     "latitude": 1.375,
     "longitude": 103.897,
     "page": 1,
     "per_page": 5
    }
    result = JSON.parse(response.body)
    assert_equal response.code, "200"
    assert_equal result.count, 1
  end

end