//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Maciek on 15/04/2023.
//

import Foundation

struct NetworkManager: NetworkService {
    
    private let scheme = "https"
    private let host = "dataservice.accuweather.com"
    private let apiKey = "CpoAeShKLVpGztcstZ32eFPjcikAtxtq"
    
    func getCities(matching name: String, _ completion: @escaping (Result<Cities, Error>) -> Void) {
        var components = provideURLComponents(for: API.getCities)
        components.queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        guard let url = components.url else {
            preconditionFailure("URL construction failed")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let cities = try JSONDecoder().decode(Cities.self, from: data)
                        completion(.success(cities))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func getCurrentConditions(for city: City, _ completion: @escaping (Result<WeatherList, Error>) -> Void) {
        var components = provideURLComponents(for: API.getCurrentConditions(city.id))
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        guard let url = components.url else {
            preconditionFailure("URL construction failed")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let currentCondtions = try JSONDecoder().decode(WeatherList.self, from: data)
                        completion(.success(currentCondtions))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func getHourlyForecast(for city: City, _ completion: @escaping (Result<HourlyForecast, Error>) -> Void) {
        var components = provideURLComponents(for: API.getHourlyForecast(city.id))
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "metric", value: "true"),
        ]
        
        guard let url = components.url else {
            preconditionFailure("URL construction failed")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let currentCondtions = try JSONDecoder().decode(HourlyForecast.self, from: data)
                        completion(.success(currentCondtions))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }


}

extension NetworkManager {
    private func provideURLComponents(for api: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = api.path
        
        return components
    }
}
