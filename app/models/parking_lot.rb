class ParkingLot < ApplicationRecord

  validates :address, :car_park_no, :latitude, :longitude, presence: true
  validates :car_park_no, uniqueness: true

  geocoded_by :latitude => :latitude,
              :longitude => :longitude

  def self.fetch_nearest(latitude:, longitude:, page:, per_page:)
    page = page.present? ? page.to_i : 1
    per_page = per_page.present? ? per_page.to_i : 20
    where("available_lots > 0").near([latitude, longitude], 5).page(page.to_i).per(per_page.to_i)
  end

end