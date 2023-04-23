//
//  Weather.swift
//  WeatherApp
//
//  Created by Maciek on 15/04/2023.
//

import Foundation

typealias WeatherList = [Weather]

struct Weather: Decodable {
    let currentTemperature: Temperature
    let conditions: String
    let precipitation: Bool
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "Temperature"
        case conditions = "WeatherText"
        case precipitation = "HasPrecipitation"
    }
}

struct Temperature: Decodable {
    let metric: TemperatureUnit
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
    }
}

struct TemperatureUnit: Decodable {
    let value: Float
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
}
