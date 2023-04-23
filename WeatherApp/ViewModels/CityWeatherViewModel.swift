//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Maciek on 19/04/2023.
//

import Foundation

class CityWeatherViewModel {
    var onDownloadCompleted: ((Bool, Error?) -> Void)?
    var onAdditionalDownloadCompleted: ((Bool, Error?) -> Void)?

    private(set) var city: City
    private(set) var weather: Weather?
    private(set) var forecastWeather: HourlyForecast?
    private var networkService: NetworkService?
    
    init(city: City) {
        self.city = city
    }
    
    func currentTemperatureColor() -> Color {
        return textColor(for: weather?.currentTemperature.metric.value ?? 0.0)
    }
    
    func textColor(for temperature: Float) -> Color {
        let range = 10...20
        let temperature = Int(temperature)
           
        if range.lowerBound > temperature {
                return .coldTemperature
        } else if range.upperBound < temperature {
                return .warmTemperature
        }
        
        return .normalTemperature
    }
}

//MARK: - Extensions

extension CityWeatherViewModel {
    
    func downloadWeather() {
        downloadWeather(for: city) { [weak self] weather, error in
            guard weather != nil else {
                self?.onDownloadCompleted?(false, error)
                return
            }
          
            self?.onDownloadCompleted?(true, error)
        }
    }
    
    private func downloadWeather(for city: City, _ completion: @escaping (Weather?, Error?) -> Void) {
        networkService = NetworkManager()
        networkService?.getCurrentConditions(for: city) { result in
            switch result {
            case .success(let weatherList):
                self.weather = weatherList.first!
                completion(self.weather, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
    func downloadHourlyForecast() {
        downloadHourlyForecast(for: city) { [weak self] weather, error in
            guard weather != nil else {
                self?.onAdditionalDownloadCompleted?(false, error)
                return
            }
          
            self?.onAdditionalDownloadCompleted?(true, error)
        }
    }
    
    private func downloadHourlyForecast(for city: City, _ completion: @escaping (HourlyForecast?, Error?) -> Void) {
        networkService = NetworkManager()
        networkService?.getHourlyForecast(for: city) { result in
            switch result {
            case .success(let weatherList):
                self.forecastWeather = weatherList
                completion(self.forecastWeather, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
}
