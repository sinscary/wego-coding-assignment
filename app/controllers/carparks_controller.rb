class CarparksController < ApplicationController

  before_action :validate_params

  def nearest
    nearest_available = ParkingLot.fetch_nearest(
      longitude: params["longitude"],
      latitude: params["latitude"],
      page: params["page"],
      per_page: params["per_page"]
    )
    result = ResponseService.build_response(carpark_info: nearest_available)
    render json: result, status: 200
  rescue StandardError => error
    render json: {
      error: error.message
    }, status: 500
  end

  private
  def validate_params
    unless params["longitude"].present? && params["latitude"].present?
      render json: {
        error: "longitude and latitude are required"
      }, status: 400
    end
  end

end