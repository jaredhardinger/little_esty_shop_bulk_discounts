require 'pry'
require 'httparty'
require './app/poros/holiday'
require './app/services/holiday_service'

class HolidaySearch
  def next_three_holidays
    service.holidays.first(3).map do |data|
      Holiday.new(data)
    end
  end

  def service
    HolidayService.new
  end
end