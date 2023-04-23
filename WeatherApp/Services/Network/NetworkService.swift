//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Maciek on 15/04/2023.
//

import Foundation

protocol NetworkService {
    func getCities(matching name: String, _ completion: @escaping (Result<Cities, Error>) -> Void)
    func getCurrentConditions(for city: City, _ completion: @escaping (Result<WeatherList, Error>) -> Void)
    func getHourlyForecast(for city: City, _ completion: @escaping (Result<HourlyForecast, Error>) -> Void)
}

enum API {
    case getCities
    case getCurrentConditions(String)
    case getHourlyForecast(String)
    
    var path: String {
        switch self {
        case .getCities:
            return "/locations/v1/cities/autocomplete"
        case .getCurrentConditions(let cityCode):
            return "/currentconditions/v1/\(cityCode)"
        case .getHourlyForecast(let cityCode):
            return "/forecasts/v1/hourly/12hour/\(cityCode)"
        }
    }
}
