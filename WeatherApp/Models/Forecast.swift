//
//  Forecast.swift
//  WeatherApp
//
//  Created by Maciek on 23/04/2023.
//

import Foundation

typealias HourlyForecast = [Forecast]

struct Forecast: Decodable {
    let date: String
    let temperature: ForecastTemperature
    
    enum CodingKeys: String, CodingKey {
        case date = "DateTime"
        case temperature = "Temperature"
    }
}

struct ForecastTemperature: Decodable {
    let value: Float
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
}

// MARK: -

extension Forecast {
    func forecastHour() -> String {
        guard let date = dateFormat() else {
            return ""
        }
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return String("\(hour):\(minute)0 h")
    }
    
    private func dateFormat() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: date)
    }
}
