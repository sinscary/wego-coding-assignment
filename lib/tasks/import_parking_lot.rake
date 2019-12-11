require 'csv'
require 'net/http'


desc "task to import parking lot data from csv to db"
# task :import_parking_lot_data => :environment do
#   csv_text = File.read(File.join(Rails.root, '/test/fixtures/files/hdb-carpark-information.csv'))
#   csv = CSV.parse(csv_text, :headers => true)
#   Parallel.each(csv, in_threads: 5) do|row|
#     coordinate_convert_api = "https://developers.onemap.sg/commonapi/convert/3414to4326?X=#{row[2]}&Y=#{row[3]}"
#     response = Net::HTTP.get(URI.parse(coordinate_convert_api))
#     result = JSON.parse(response)
#     ActiveRecord::Base.transaction do
#       ParkingLot.create!(
#         car_park_no: row[0],
#         address: row[1],
#         latitude: result["latitude"],
#         longitude: result["longitude"]
#       )
#     end
#   end
# end


task :import_parking_lot_data => :environment do
  csv_text = File.read(File.join(Rails.root, '/test/fixtures/files/hdb-carpark-information.csv'))
  csv = CSV.parse(csv_text, :headers => true)
  # I tried using parallel record creation but sqlite doesn't support concurrent writes
  # checkout the above rake task for Parallel impelementation
  csv.each do|row|
    coordinate_convert_api = "https://developers.onemap.sg/commonapi/convert/3414to4326?X=#{row["x_coord"]}&Y=#{row["y_coord"]}"
    response = Net::HTTP.get(URI.parse(coordinate_convert_api))
    result = JSON.parse(response)
    ActiveRecord::Base.transaction do
      ParkingLot.create!(
        car_park_no: row["car_park_no"],
        address: row["address"],
        latitude: result["latitude"],
        longitude: result["longitude"]
      )
    end
  end
end


desc "this task fetches latest availability of all the lots"
task :import_latest_parking_availability => :environment do
  # Not using parallel gem because sqlite doesn't support concurrent writes
  parking_availability_url = "https://api.data.gov.sg/v1/transport/carpark-availability"
  response = Net::HTTP.get(URI.parse(parking_availability_url))
  result = JSON.parse(response)
  availabilities = result["items"][0]["carpark_data"]
  availabilities.each do|availability|
    parking_lot = ParkingLot.find_by(car_park_no: availability["carpark_number"])
    next unless parking_lot.present?
    carpark_info = availability["carpark_info"]
    parking_lot.update_attributes(
      total_lots: carpark_info[0]["total_lots"],
      available_lots: carpark_info[0]["lots_available"]
    )
  end
end