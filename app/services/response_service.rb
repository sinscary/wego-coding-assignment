class ResponseService

  def self.build_response(carpark_info:)
    result = Array.new
    carpark_info.each do|row|
      result << {
        "address": row.address,
        "latitude": row.latitude,
        "longitude": row.longitude,
        "total_lots": row.total_lots,
        "available_lots": row.available_lots
      }
    end
    result
  end

end