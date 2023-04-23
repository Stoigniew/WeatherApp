//
//  SearchedCitiesStorage.swift
//  WeatherApp
//
//  Created by Maciek on 19/04/2023.
//

import Foundation

class SearchedCitiesStorage {
    
    private let key = "cities_storage_key"
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func retrieveCities() -> Cities? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        let cities = try? JSONDecoder().decode(Cities.self, from: data)
        return cities
    }
    
    func store(city: City) {
        var cities = retrieveCities() ?? []
        cities.append(city)
        let encodedCities = try? JSONEncoder().encode(cities)
        userDefaults.set(encodedCities, forKey: key)
    }
}
